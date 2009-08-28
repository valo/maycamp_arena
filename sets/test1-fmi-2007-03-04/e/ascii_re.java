/*
    Solution for NEERC'2006 Problem A: ASCII Art
    (C) Roman Elizarov
    Note: this solution attempts to check correctness of the input
*/

import java.io.*;

public class ascii_re {
	static final double EPS = 1e-10;

	public static void main(String[] args) throws Exception {
		new ascii_re().go();
	}

	int n;
	int w;
	int h;
	int[] x;
	int[] y;
	double[][] c;
	double[] tx = new double[4];
	double[] ty = new double[4];

	void go() throws Exception {
		Scanner in = new Scanner(new File("ascii.in"));

		n = in.nextInt();
		w = in.nextInt();
		h = in.nextInt();
		in.nextLine();

		assert n >= 3 && n <= 100;
		assert w >= 1 && w <= 100;
		assert h >= 1 && h <= 100;

		x = new int[n];
		y = new int[n];
		for (int i = 0; i < n; i++) {
			x[i] = in.nextInt();
			y[i] = in.nextInt();
			in.nextLine();
			assert x[i] >= 0 && x[i] <= w;
			assert y[i] >= 0 && y[i] <= h;
		}
		assert!selfIntersections() : "self intersections";
		in.close();

		c = new double[w][h];
		for (int i = 0; i < n; i++)
			draw(x[i], y[i], x[(i + 1) % n], y[(i + 1) % n]);

		PrintStream out = new PrintStream(new File("ascii.out"));
		for (int y = h; --y >= 0;) {
			for (int x = 0; x < w; x++) {
				double ff = c[x][y];
				char ch;
				assert ff > -EPS : "clockwise order";
				if (ff < 0.25 - EPS)
					ch = '.';
				else if (ff < 0.50 - EPS)
					ch = '+';
				else if (ff < 0.75 - EPS)
					ch = 'o';
				else if (ff < 1.00 - EPS)
					ch = '$';
				else
					ch = '#';
				out.print(ch);
			}
			out.println();
		}
		out.close();
	}

	void draw(int x1, int y1, int x2, int y2) {
		if (x1 == x2)
			return;
		double mul = 1;
		if (x1 > x2) {
			int t = x1;
			x1 = x2;
			x2 = t;
			t = y1;
			y1 = y2;
			y2 = t;
			mul = -1;
		}
		assert x1 < x2;
		double r = (double) (y2 - y1) / (x2 - x1);
		for (int x = x1; x < x2; x++) {
			double ya = y1 + r * (x - x1);
			double yb = y1 + r * (x + 1 - x1);
			int bot = (int) (Math.min(ya, yb) + EPS);
			int top = (int) (Math.max(ya, yb) - EPS);
			for (int y = 0; y < bot; y++)
				c[x][y] += mul;
			for (int y = bot; y <= top; y++) {
				if (Math.abs(r) < EPS)
					continue;
				double xa = x + (y - ya) / r;
				double xb = x + (y + 1 - ya) / r;
				xa = xa < x ? x : xa > x + 1 ? x + 1 : xa;
				xb = xb < x ? x : xb > x + 1 ? x + 1 : xb;
				if (xa > xb) {
					double t = xa;
					xa = xb;
					xb = t;
				}
				tx[0] = x;
				tx[1] = xa;
				tx[2] = xb;
				tx[3] = x + 1;
				for (int i = 0; i < 4; i++) {
					double t = y1 + r * (tx[i] - x1);
					ty[i] = t < y ? y : t > y + 1 ? y + 1 : t;
				}
				double s = 0;
				for (int i = 0; i < 3; i++)
					s += (tx[i + 1] - tx[i]) * (ty[i + 1] + ty[i] - 2 * y) / 2;
				c[x][y] += mul * s;
			}
		}
	}

	//----------------- just for validation ------------------

	boolean selfIntersections() {
		for (int i = 0; i < n; i++) {
			if (x[i] == x[(i + 1) % n] && y[i] == y[(i + 1) % n])
				return true;
			for (int j = i + 2; j < n; j++)
				if ((j + 1) % n != i &&
						intersects(
								x[i], y[i], x[(i + 1) % n], y[(i + 1) % n],
								x[j], y[j], x[(j + 1) % n], y[(j + 1) % n]))
					return true;
		}
		return false;
	}

	boolean intersects(int x1, int y1, int x2, int y2, int x3, int y3, int x4, int y4) {
		//System.out.printf("(%d,%d)-(%d,%d) with (%d,%d)-(%d,%d)%n", x1, y1, x2, y2, x3, y3, x4, y4);
		return irange(x1, x2, x3, x4) && irange(y1, y2, y3, y4) &&
				samedir(x1, y1, x3, y3, x2, y2, x4, y4) &&
				samedir(x3, y3, x1, y1, x4, y4, x2, y2);
	}

	boolean irange(int x1, int x2, int x3, int x4) {
		return between(x1, x3, x4) || between(x2, x3, x4) ||
				between(x3, x1, x2) || between(x4, x1, x2);
	}

	boolean between(int x, int x1, int x2) {
		if (x1 > x2) {
			int t = x1;
			x1 = x2;
			x2 = t;
		}
		return x >= x1 && x <= x2;
	}

	boolean samedir(int x0, int y0, int x1, int y1, int x2, int y2, int x3, int y3) {
		return dir(x1 - x0, y1 - y0, x2 - x0, y2 - y0) *
				dir(x2 - x0, y2 - y0, x3 - x0, y3 - y0) >= 0;
	}

	int dir(int x1, int y1, int x2, int y2) {
		int d = x1 * y2 - y1 * x2;
		return d < 0 ? -1 : d > 0 ? 1 : 0;
	}

//----------------- just for validation ------------------

	/**
	 * Strict scanner to veryfy 100% correspondence between input files and input file format specification.
	 * It is a drop-in replacement for {@link java.util.Scanner} that could added to a soulution source
	 * without breaking its ability to work with {@link java.util.Scanner}.
	 */
	public static class Scanner {
		private final BufferedReader in;
		private String line = "";
		private int pos;
		private int lineNo;

		public Scanner(File source) throws FileNotFoundException {
			in = new BufferedReader(new FileReader(source));
			nextLine();
		}

		public void close() {
			assert line == null : "Extra data at the end of file";
			try {
				in.close();
			} catch (IOException e) {
				throw new AssertionError("Failed to close with " + e);
			}
		}

		public void nextLine() {
			assert line != null : "EOF";
			assert pos == line.length() : "Extra characters on line " + lineNo;
			try {
				line = in.readLine();
			} catch (IOException e) {
				throw new AssertionError("Failed to read line with " + e);
			}
			pos = 0;
			lineNo++;
		}

		public String next() {
			assert line != null : "EOF";
			assert line.length() > 0 : "Empty line " + lineNo;
			if (pos == 0)
				assert line.charAt(0) > ' ' : "Line " + lineNo + " starts with whitespace";
			else {
				assert pos < line.length() : "Line " + lineNo + " is over";
				assert line.charAt(pos) == ' ' : "Wrong whitespace on line " + lineNo;
				pos++;
				assert pos < line.length() : "Line " + lineNo + " is over";
				assert line.charAt(0) > ' ' : "Line " + lineNo + " has double whitespace";
			}
			StringBuilder sb = new StringBuilder();
			while (pos < line.length() && line.charAt(pos) > ' ')
				sb.append(line.charAt(pos++));
			return sb.toString();
		}

		public int nextInt() {
			String s = next();
			assert s.length() == 1 || s.charAt(0) != '0' : "Extra leading zero in number " + s + " on line " + lineNo;
			assert s.charAt(0) != '+' : "Extra leading '+' in number " + s + " on line " + lineNo;
			try {
				return Integer.parseInt(s);
			} catch (NumberFormatException e) {
				throw new AssertionError("Malformed number " + s + " on line " + lineNo);
			}
		}
	}
}

