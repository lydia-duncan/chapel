

__get_docker_tag() {
  local os=$1
  local package_name=$2
  local chapel_version=$3
  local package_version=$4

  echo "chapel/${package_name}-${chapel_version}-${os}:${package_version}"
}


__package_type_from_os() {
  local pkg_type
  case $1 in
    "amzn2023" | "fc41" | "fc42" | "el9" | "el10")
    pkg_type="rpm"
    ;;
    "debian11" | "debian12" | "ubuntu22" | "ubuntu24")
    pkg_type="apt"
    ;;
    *)
    pkg_type="unknown"
    ;;
  esac
  echo $pkg_type
}
__docker_image_from_os() {
  local docker_image_base
  case $1 in
    "amzn2023")
    docker_image_base="amazonlinux:2023"
    ;;
    "fc41")
    docker_image_base="fedora:41"
    ;;
    "fc42")
    docker_image_base="fedora:42"
    ;;
    "el9")
    docker_image_base="rockylinux/rockylinux:9"
    ;;
    "el10")
    docker_image_base="almalinux:10"
    ;;
    "debian11")
    docker_image_base="debian:11"
    ;;
    "debian12")
    docker_image_base="debian:12"
    ;;
    "ubuntu22")
    docker_image_base="ubuntu:22.04"
    ;;
    "ubuntu24")
    docker_image_base="ubuntu:24.04"
    ;;
    *)
    docker_image_base="unknown"
    ;;
  esac
  echo $docker_image_base
}

__wget_chpl_release() {
  local chapel_version=$1
  local release_dir="${CHPL_HOME}/util/packaging/tarballs"
  local release_file="${release_dir}/chapel-${chapel_version}.tar.gz"
  local url="https://github.com/chapel-lang/chapel/releases/download/${chapel_version}/chapel-${chapel_version}.tar.gz"

  if [ ! -f $release_file ]; then
    mkdir -p $release_dir
    wget -O $release_file $url
  fi
}

__build_all_packages() {
  if [[ $# -ne 5 ]]; then
    echo "Usage: __build_all_packages <os> <package_name> <chapel_version> <package_version> <para>"
    return
  fi
  __build_packages $1 $2 $3 $4 '--platform=linux/amd64,linux/arm64' $5
}
__build_x8664_package() {
  if [[ $# -ne 5 ]]; then
    echo "Usage: __build_x8664_package <os> <package_name> <chapel_version> <package_version> <para>"
    return
  fi
  __build_packages $1 $2 $3 $4 '--platform=linux/amd64' $5
}
__build_arm64_package() {
  if [[ $# -ne 5 ]]; then
    echo "Usage: __build_arm64_package <os> <package_name> <chapel_version> <package_version> <para>"
    return
  fi
  __build_packages $1 $2 $3 $4 '--platform=linux/arm64' $5
}
__build_native_package() {
  if [[ $# -ne 5 ]]; then
    echo "Usage: __build_packages <os> <package_name> <chapel_version> <package_version> <para>"
    return
  fi
  __build_packages $1 $2 $3 $4 '' $5
}

__build_packages() {
  local os=$1
  local package_name=$2
  local chapel_version=$3
  local package_version=$4
  local architecture_string=$5
  local para=$6
  local pkg_type=$(__package_type_from_os $os)
  local docker_dir_name=$os
  local docker_image_base=$(__docker_image_from_os $os)

  if [ $pkg_type = "unknown" ]; then
    echo "Unknown package type for OS $os"
    return 1
  fi
  if [ -z "$docker_image_base" ]; then
    echo "Unknown docker image base for OS $os"
    return 1
  fi

  __wget_chpl_release $chapel_version

  local package_dir="${CHPL_HOME}/util/packaging/${pkg_type}/${docker_dir_name}"
  local fill_script="${CHPL_HOME}/util/packaging/${pkg_type}/common/fill_docker_template.py"
  docker_tag=$(__get_docker_tag $os $package_name $chapel_version $package_version)

  pushd ${package_dir}

  # Try to pull the latest version of this image, as a best effort.
  docker pull $docker_image_base || true
  # Whether we pulled successfully or not, use the image SHA256 digest to
  # identify the copy of it we have locally (if present), so build can proceed
  # with that version.
  if [ -z "$(docker image ls -q $docker_image_base)" ]; then
    echo "Error: Failed to pull image $docker_image_base and a copy does not exist locally"
    exit 1
  fi
  local docker_image_name_full="$(docker inspect --format='{{index .RepoDigests 0}}' $docker_image_base)"
  echo "Using image digest ${docker_image_name_full} for $docker_image_base"

  # if there is a template file, use it to generate the Dockerfile
  if [ -f Dockerfile.template ]; then
    ${fill_script} Dockerfile.template
  fi
  set -x

  DOCKER_BUILDKIT=1 docker buildx build \
    $architecture_string \
    --output=type=local,dest=../build/$os-$package_name-$chapel_version-$package_version \
    --target=artifact \
    --build-arg "BASENAME=$package_name" \
    --build-arg "CHAPEL_VERSION=$chapel_version" \
    --build-arg "PACKAGE_VERSION=$package_version" \
    --build-arg "OS_NAME=$os" \
    --build-arg "DOCKER_DIR_NAME=$docker_dir_name" \
    --build-arg "DOCKER_IMAGE_NAME_FULL=$docker_image_name_full" \
    --build-arg "PARALLEL=$para" \
    -t $docker_tag \
    -f Dockerfile ../..
  popd
}

__build_image() {
  # use this to build a container image for local testing
  local os=$1
  local package_name=$2
  local chapel_version=$3
  local package_version=$4
  local para=$5
  local pkg_type=$(__package_type_from_os $os)
  local docker_dir_name=$os
  local docker_image_base=$(__docker_image_from_os $os)

  if [ $pkg_type = "unknown" ]; then
    echo "Unknown package type for OS $os"
    return 1
  fi
  if [ -z "$docker_image_base" ]; then
    echo "Unknown docker image base for OS $os"
    return 1
  fi

  __wget_chpl_release $chapel_version

  local package_dir="${CHPL_HOME}/util/packaging/${pkg_type}/${docker_dir_name}"
  local fill_script="${CHPL_HOME}/util/packaging/${pkg_type}/common/fill_docker_template.py"
  docker_tag=$(__get_docker_tag $os $package_name $chapel_version $package_version)

  pushd ${package_dir}

  # Try to pull the latest version of this image, as a best effort.
  docker pull $docker_image_base || true
  # Whether we pulled successfully or not, use the image SHA256 digest to
  # identify the copy of it we have locally (if present), so build can proceed
  # with that version.
  if [ -z "$(docker image ls -q $docker_image_base)" ]; then
    echo "Error: Failed to pull image $docker_image_base and a copy does not exist locally"
    exit 1
  fi
  local docker_image_name_full="$(docker inspect --format='{{index .RepoDigests 0}}' $docker_image_base)"
  echo "Using image digest ${docker_image_name_full} for $docker_image_base"

  # if there is a template file, use it to generate the Dockerfile
  if [ -f Dockerfile.template ]; then
    ${fill_script} Dockerfile.template
  fi

  DOCKER_BUILDKIT=1 docker buildx build \
    --load \
    --target=build \
    --build-arg "BASENAME=$package_name" \
    --build-arg "CHAPEL_VERSION=$chapel_version" \
    --build-arg "PACKAGE_VERSION=$package_version" \
    --build-arg "OS_NAME=$os" \
    --build-arg "DOCKER_DIR_NAME=$docker_dir_name" \
    --build-arg "DOCKER_IMAGE_NAME_FULL=$docker_image_name_full" \
    --build-arg "PARALLEL=$para" \
    -t $docker_tag \
    -f Dockerfile ../..
  popd
}
__run_container() {
  local os=$1
  local package_name=$2
  local chapel_version=$3
  local package_version=$4

  docker_tag=$(__get_docker_tag $os $package_name $chapel_version $package_version)

  docker run -it --rm $docker_tag
}

__test_package() {
  python3 $CHPL_HOME/util/packaging/common/test_package.py $@
}
__test_all_packages() {
  for deb in $(set +e && find $CHPL_HOME/util/packaging/apt/build -name '*.deb'); do
    __test_package $deb
  done
  for rpm in $(set +e && find $CHPL_HOME/util/packaging/rpm/build -name '*.rpm'); do
    __test_package $rpm
  done
}
