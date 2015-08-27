use Time;

record R {
  var x = 13.7;
}

pragma "donor fn"
proc chpl__autoCopy(in r: R) {
  begin with (ref r) r.x = getCurrentTime();
  return r;
}

var r0: R;
begin var r1 = r0;
