import java.io.*;
import java.math.*;
import java.text.*;

public class solution{
   static StreamTokenizer in = 
      new StreamTokenizer(new InputStreamReader(System.in));

   public static void main(String[] args) throws Exception {
      BigInteger T = BigInteger.valueOf(0);
      BigInteger TB = BigInteger.valueOf(0);
      BigInteger NTB = BigInteger.valueOf(0);
      BigInteger S = BigInteger.valueOf(0);
      BigInteger MAX = BigInteger.valueOf(1);
      int j;
      for (j=0;j<100;j++) MAX = MAX.multiply(BigInteger.valueOf(10));
      for(;;){
         int i,t,a,b;
         if (in.nextToken() != StreamTokenizer.TT_NUMBER) break;
         t = (int) in.nval;
         if (in.nextToken() != StreamTokenizer.TT_NUMBER) break;
         a = (int) in.nval;
         if (in.nextToken() != StreamTokenizer.TT_NUMBER) break;
         b = (int) in.nval;

         //System.out.print("(");
         //System.out.print(t);
         //System.out.print("^");
         //System.out.print(a);
         //System.out.print("-1)/(");
         //System.out.print(t);
         //System.out.print("^");
         //System.out.print(b);
         //System.out.print("-1) ");
         if (t == 1 || a%b != 0) {
            System.out.print("bad!\n");
            continue;
         }
      
         T = BigInteger.valueOf(t);
         TB = BigInteger.valueOf(1);
         for (i=0;i<b;i++){
            TB = TB.multiply(T);
            if (TB.compareTo(MAX) >= 0) break;
         }
         NTB = BigInteger.valueOf(1);
         S = BigInteger.valueOf(0);
         for (i=0;i<a;i+=b) {
            S = S.add(NTB);
            if (S.compareTo(MAX) >= 0) break;
            NTB = NTB.multiply(TB);
         }
         if (S.compareTo(MAX) >= 0) System.out.print("bad!");
         else System.out.print(S);
         System.out.print("\n");
      }
   }
}
