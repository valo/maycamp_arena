
{$N+}

type
  Float = Double;

const
  pi = 3.141592654;

var
  f: Text;
  x1, y1, r1, x2, y2, r2, d, a1, a2, b, A: Float;


function atan2(a, b: Float): Float;
begin
  if abs(b) < 1e-6 then atan2 := pi / 2
  else if b > 0 then atan2 := arctan(a / b)
  else atan2 := pi + arctan(a / b);
end;

begin
  Assign(f, 'input.txt'); Reset(f);
  Read(f, x1, y1, r1, x2, y2, r2);
  Close(f);
  if r1 < r2 then begin d := r1; r1 := r2; r2 := d; end;
  d := sqrt(sqr(x1 - x2) + sqr(y1 - y2));
  {d = a1+a2; a1^2 - a2^2 = r1^2 - r2^2 => a1-a2 = (r1^2-r2^2)/d;}
  if d + r2 <= r1 then begin
    A := pi * sqr(r2);
  end else if r1 + r2 <= d then begin
    A := 0.0;
  end else begin
    a1 := ((sqr(r1) - sqr(r2))/d + d) * 0.5;
    a2 := d - a1;
    b := sqrt(sqr(r1) - sqr(a1));
    A := sqr(r1)*atan2(b, a1) - a1*b;
    A := A + sqr(r2)*atan2(b, a2) - a2*b;
  end;
  Assign(f, 'output.txt'); Rewrite(f);
  Writeln(f, A:0:3);
  Close(f);
end.
