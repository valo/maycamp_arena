Const
  MaxN=152;
  Infinity=200;
Var
  I,N,P,M:LongInt;
  Edge:Array[1..MaxN]Of Record A,B:LongInt; End;
  Min:Array[1..MaxN,1..MaxN]Of Byte;
  Visited:Array[1..MaxN]Of Boolean;
  Res:LongInt;
Procedure DFS(Start:LongInt);
Var
  I,J,K:LongInt;
  Next:LongInt;
Begin
  Visited[Start]:=True;
  FillChar(Min[Start],SizeOf(Min[Start]),Infinity);
  Min[Start][1]:=0;
  For I:=1 To M Do
    If (Edge[I].A=Start) Or (Edge[I].B=Start) Then Begin
      If Edge[I].A=Start Then
        Next:=Edge[I].B
      Else
        Next:=Edge[I].A;
      If Not Visited[Next] Then Begin
        DFS(Next);
        For J:=N DownTo 1 Do If Min[Start][J]<Infinity Then Begin
          For K:=1 To N Do
            If Min[Next][K]<Infinity Then
              If Min[Start][J+K]>Min[Start][J]+Min[Next][K] Then
                Min[Start][J+K]:=Min[Start][J]+Min[Next][K];
          Inc(Min[Start][J]);
        End;
      End;
    End;
End;
Begin
  Assign(Input,'i.in');
  ReSet(Input);
  Read(N,P);
  For M:=1 to N-1 do
    Read(Edge[M].A,Edge[M].B);
  M:=N-1;
  Close(Input);
  FillChar(Visited,SizeOf(Visited),False);
  DFS(1);
  Res:=Min[1][P];
  For I:=2 To N Do
    If Min[I][P]+1<Res Then
      Res:=Min[I][P]+1;
  Assign(Output,'i.out');
  ReWrite(Output);
  WriteLn(Res);
  Close(Output);
End.

