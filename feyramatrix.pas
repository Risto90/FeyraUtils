unit FeyraMatrix; //<Поддержка матриц для FreePascal

{$i feyraconf.inc}

interface

uses
  Classes;

type
  FMatrix = class
    private
      type
        TypeList = (I,R,S,C,B);
        MatrixCellRecord = record
          case TypeMatrix: TypeList of
            I: (IntField:integer);
            R: (RealField:real);
            S: (StrField:shortstring);
            C: (CharField:char);
            B: (BoolField:boolean);
        end;
        MRow = Array of MatrixCellRecord;
        Matrix = Array of MRow;
      var
        MRead: Matrix;
        DCell: MatrixCellRecord;
        DRows: MRow;
        DColumns: MRow;
    protected
      function GetNumRows:integer;
      function GetNumColumns:integer;
      procedure SetNumRows(NumRows:integer);
      procedure SetNumColumns(NumColumns:integer);
      function GetCell(n,m: integer):variant;
      procedure SetCell(n,m: integer; Value: variant);
    public
      property Rows: integer read GetNumRows write SetNumRows;
      property Columns: integer read GetNumColumns write SetNumColumns;
      property All: Matrix read MRead write MRead;
      property Cell[n,m: integer]: variant read GetCell write SetCell;default;
  end; {<@abstract(Основной класс для работы с матрицами)
  @member(Rows Число строк матрицы)
  @member(Columns Число столбцов матрицы)
  @member(All Запрос или запись матрицы целиком)}

  IMatrix = class(FMatrix)
    public
      constructor Create(h, w, def: integer);
  end; {<@abstract(Класс целочисленной матрицы)}

  SMatrix = class(FMatrix)
    public
      constructor Create(h, w: integer; def: string);
  end; {<@abstract(Класс строковой матрицы)}

  CMatrix = class(FMatrix)
    public
      constructor Create(h, w: integer; def: char);
  end; {<@abstract(Класс символьной матрицы)}

  BMatrix = class(FMatrix)
    public
      constructor Create(h, w: integer; def: boolean);
  end; {<@abstract(Класс булевой матрицы)}

  RMatrix = class(FMatrix)
    public
      constructor Create(h, w: integer; def: real);
  end; {<@abstract(Класс числовой матрицы)}

implementation

uses
  SysUtils, FeyraList;

function FMatrix.GetNumRows:integer;
begin
  GetNumRows := length(MRead);
end;

function FMatrix.GetNumColumns:integer;
begin
  GetNumColumns := length(MRead[0]);
end;

procedure FMatrix.SetNumRows(NumRows:integer);
begin
  SetLength(MRead, NumRows);
  SetLength(DRows, NumRows);
end;

procedure FMatrix.SetNumColumns(NumColumns:integer);
var
  i:integer;
begin
  for i := 0 to Rows-1 do SetLength(MRead[i], NumColumns);
  SetLength(DColumns, NumColumns);
end;

function FMatrix.GetCell(n,m: integer):variant;
begin
  if n<>0 then
    if m<>0 then case Self.DCell.TypeMatrix of
      I: result := Self.MRead[n-1][m-1].IntField;
      R: result := Self.MRead[n-1][m-1].RealField;
      S: result := Self.MRead[n-1][m-1].StrField;
      C: result := Self.MRead[n-1][m-1].CharField;
      B: result := Self.MRead[n-1][m-1].BoolField;
    end
    else case Self.DCell.TypeMatrix of
      I: result := Self.DRows[n-1].IntField;
      R: result := Self.DRows[n-1].RealField;
      S: result := Self.DRows[n-1].StrField;
      C: result := Self.DRows[n-1].CharField;
      B: result := Self.DRows[n-1].BoolField;
    end
  else if m=0 then case Self.DCell.TypeMatrix of
    I: result := Self.DCell.IntField;
    R: result := Self.DCell.RealField;
    S: result := Self.DCell.StrField;
    C: result := Self.DCell.CharField;
    B: result := Self.DCell.BoolField;
  end
  else case Self.DCell.TypeMatrix of
    I: result := Self.DColumns[m-1].IntField;
    R: result := Self.DColumns[m-1].RealField;
    S: result := Self.DColumns[m-1].StrField;
    C: result := Self.DColumns[m-1].CharField;
    B: result := Self.DColumns[m-1].BoolField;
  end;
end;

procedure FMatrix.SetCell(n,m: integer; Value: variant);
var
  ci, cj: integer;
  OldDefValue: variant;
begin
  if n<>0 then
    if m<>0 then case Self.DCell.TypeMatrix of
      I: Self.MRead[n-1][m-1].IntField := Value;
      R: Self.MRead[n-1][m-1].RealField := Value;
      S: Self.MRead[n-1][m-1].StrField := Value;
      C: Self.MRead[n-1][m-1].CharField := Value;
      B: Self.MRead[n-1][m-1].BoolField := Value;
    end
    else case Self.DCell.TypeMatrix of
      I: Self.DRows[n-1].IntField := Value;
      R: Self.DRows[n-1].RealField := Value;
      S: Self.DRows[n-1].StrField := Value;
      C: Self.DRows[n-1].CharField := Value;
      B: Self.DRows[n-1].BoolField := Value;
    end
  else if m=0 then begin
    case Self.DCell.TypeMatrix of
      I: OldDefValue := Self.DCell.IntField;
      R: OldDefValue := Self.DCell.RealField;
      S: OldDefValue := Self.DCell.StrField;
      C: OldDefValue := Self.DCell.CharField;
      B: OldDefValue := Self.DCell.BoolField;
    end;
    for ci := 0 to Rows do
      for cj := 0 to Columns do
        if ci<>0 then
          if cj<>0 then
            begin
              Self.MRead[ci-1][cj-1].TypeMatrix := Self.DCell.TypeMatrix;
              if ((Self.DCell.TypeMatrix = I) or (Self.DCell.TypeMatrix = R) or (Self.DCell.TypeMatrix = B)) then begin
                if ((Self[ci,cj] = OldDefValue) or (Self[ci,cj] = 0)) and (Self[ci,cj]<>Value) then
                  Self[ci,cj] := Value
              end
              else
                if ((Self[ci,cj] = OldDefValue) or (Self[ci,cj] = '')) and (Self[ci,cj]<>Value) then
                  Self[ci,cj] := Value;
            end
          else Self.DRows[ci-1].TypeMatrix := Self.DCell.TypeMatrix
        else if cj<>0 then
            Self.DColumns[cj-1].TypeMatrix := Self.DCell.TypeMatrix;
    case Self.DCell.TypeMatrix of
      I: Self.DCell.IntField := Value;
      R: Self.DCell.RealField := Value;
      S: Self.DCell.StrField := Value;
      C: Self.DCell.CharField := Value;
      B: Self.DCell.BoolField := Value;
    end;
  end
  else case Self.DCell.TypeMatrix of
    I: Self.DColumns[m-1].IntField := Value;
    R: Self.DColumns[m-1].RealField := Value;
    S: Self.DColumns[m-1].StrField := Value;
    C: Self.DColumns[m-1].CharField := Value;
    B: Self.DColumns[m-1].BoolField := Value;
  end;
end;

constructor IMatrix.Create(h, w, def: integer);
begin
  Rows := h;
  Columns := w;
  DCell.TypeMatrix := I;
  Cell[0,0] := def;
end;

constructor SMatrix.Create(h, w: integer; def: string);
begin
  Rows := h;
  Columns := w;
  DCell.TypeMatrix := S;
  Cell[0,0] := def;
end;

constructor CMatrix.Create(h, w: integer; def: char);
begin
  Rows := h;
  Columns := w;
  DCell.TypeMatrix := C;
  Cell[0,0] := def;
end;

constructor BMatrix.Create(h, w: integer; def: boolean);
begin
  Rows := h;
  Columns := w;
  DCell.TypeMatrix := B;
  Cell[0,0] := def;
end;

constructor RMatrix.Create(h, w: integer; def: real);
begin
  Rows := h;
  Columns := w;
  DCell.TypeMatrix := R;
  Cell[0,0] := def;
end;

end.

