/* nbody_forloop + vectorized operations
 * We also shorten exponential functions using the shorthand
 * operator.
 *
 * The Great Computer Language Benchmarks Game
 * http://benchmarksgame.alioth.debian.org
 *
 * contributed by Albert Sidelnik
 *
*/

config var n = 1000;
param PI = 3.141592653589793;
const solar_mass = (4 * PI * PI);
const vecLen = {0..2};
param days_per_year = 365.24;

record Planet {
  var coord_vector : [vecLen] real; // x,y,z
  var vel_vector : [vecLen] real;   // vx,vy,vz
  var mass : real;
}

proc advance(ref B: [] Planet, dt: real) {
  for (b1, i) in zip(B, 0..) {
    for b2 in B[i+1..] {
      var d : [vecLen] real = b1.coord_vector - b2.coord_vector;
      //var d : [] real = b1.coord_vector - b2.coord_vector;
      var distance = sqrt(d[0]**2 + d[1]**2 + d[2]**2);
      var mag = dt / (distance**3);
      b1.vel_vector -= d * b2.mass * mag;
      b2.vel_vector += d * b1.mass * mag;
    }
  }
  for b in B do
    b.coord_vector += dt * b.vel_vector;
}

proc energy(B : [] Planet) : real {
  var e : real;
  for (b1,i) in zip(B,0..) {
    e += 0.5 * b1.mass * (b1.vel_vector(0)**2 +
                          b1.vel_vector(1)**2 + 
                          b1.vel_vector(2)**2);
    for b2 in B[i+1..] {
      var d : [vecLen] real = b1.coord_vector - b2.coord_vector;
      var distance = sqrt(d[0]**2 + d[1]**2 + d[2]**2);
      e -= (b1.mass * b2.mass) / distance;
    }
  }
  return e;
}

proc offset_momentum(ref B : [] Planet) {
  var p : [vecLen] real;
  for b in B do
    p += b.vel_vector * b.mass;
  B(0).vel_vector = -p / solar_mass;
}

proc main() {
  param NBODIES = 5;
  var bodies : [0..#NBODIES] Planet;
  
  var p0,v0 : [vecLen] real = (0,0,0);
  bodies(0) = new Planet(p0,v0, solar_mass);
  var p1 : [vecLen] real = (4.84143144246472090e+00,
                          -1.16032004402742839e+00,
                          -1.03622044471123109e-01);
  var v1 : [vecLen] real = (1.66007664274403694e-03 * days_per_year,
                          7.69901118419740425e-03 * days_per_year,
                          -6.90460016972063023e-05 * days_per_year);
  bodies(1) = new Planet(p1, v1, 9.54791938424326609e-04 * solar_mass);
  var p2 : [vecLen] real = (8.34336671824457987e+00,
                          4.12479856412430479e+00,
                          -4.03523417114321381e-01);
  var v2 : [vecLen] real = (-2.76742510726862411e-03 * days_per_year,
                          4.99852801234917238e-03 * days_per_year,
                          2.30417297573763929e-05 * days_per_year);
  bodies(2) = new Planet(p2, v2, 2.85885980666130812e-04 * solar_mass);
  var p3 : [vecLen] real = (1.28943695621391310e+01,
                          -1.51111514016986312e+01,
                          -2.23307578892655734e-01);
  var v3 : [vecLen] real = (2.96460137564761618e-03 * days_per_year,
                          2.37847173959480950e-03 * days_per_year,
                          -2.96589568540237556e-05 * days_per_year);
  bodies(3) = new Planet(p3,v3, 4.36624404335156298e-05 * solar_mass);
  var p4 : [vecLen] real = (1.53796971148509165e+01,
                          -2.59193146099879641e+01,
                          1.79258772950371181e-01);
  var v4 : [vecLen] real = (2.68067772490389322e-03 * days_per_year,
                          1.62824170038242295e-03 * days_per_year,
                          -9.51592254519715870e-05 * days_per_year);
  bodies(4) = new Planet(p4,v4, 5.15138902046611451e-05 * solar_mass);
  
  offset_momentum(bodies);
  writef("%{#.#########}\n", energy(bodies));
  for 1..n {
    advance(bodies, 0.01);
  }
  writef("%{#.#########}\n", energy(bodies));
}
