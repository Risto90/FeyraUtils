unit FeyraMatrix; //<Поддержка матриц для FreePascal

{$mode objfpc}{$H+}

interface

uses
  Classes;

type
  FeyraMatrix = class
    private
      type
        VarRow = Array of variant;
        VarMatrix = Array of VarRow;
      var
        MRead: VarMatrix;
    protected
      type
        IntRow = Array of integer;
        RealRow = Array of real;
        StrRow = Array of string;
        CharRow = Array of char;
        BoolRow = Array of boolean;
      var
        DCell: variant;
      procedure SetDefaultValue(DefValue:variant);
      function GetNumRows:integer;
      function GetNumColumns:integer;
      procedure SetNumRows(NumRows:integer);
      procedure SetNumColumns(NumColumns:integer);
      function GetCell(n,m: integer):variant;
      procedure SetCell(n,m: integer; Value: variant);
    public
      property Rows: integer read GetNumRows write SetNumRows;
      property Columns: integer read GetNumColumns write SetNumColumns;
      property DefCell: variant read DCell write SetDefaultValue;
      property All: VarMatrix read MRead write MRead;
      property Cell[n,m: integer]: variant read GetCell write SetCell;default;
  end; {<@abstract(Основной класс для работы с матрицами)
  @member(Rows Число строк матрицы)
  @member(Columns Число столбцов матрицы)
  @member(All Запрос или запись матрицы целиком)}

  FeyraIntMatrix = class(FeyraMatrix)
    public
      constructor Create(h, w, def: integer);
  end; {<@abstract(Класс целочисленной матрицы)}

  FeyraStrMatrix = class(FeyraMatrix)
    public
      constructor Create(h, w: integer; def: string);
  end; {<@abstract(Класс строковой матрицы)}

  FeyraCharMatrix = class(FeyraMatrix)
    public
      constructor Create(h, w: integer; def: char);
  end; {<@abstract(Класс символьной матрицы)}

  FeyraBoolMatrix = class(FeyraMatrix)
    public
      constructor Create(h, w: integer; def: boolean);
  end; {<@abstract(Класс булевой матрицы)}

  FeyraRealMatrix = class(FeyraMatrix)
    public
      constructor Create(h, w: integer; def: real);
  end; {<@abstract(Класс числовой матрицы)}

implementation

uses
  SysUtils;

function FeyraMatrix.GetNumRows:integer;
begin
  GetNumRows := length(MRead);
end;

function FeyraMatrix.GetNumColumns:integer;
begin
  GetNumColumns := length(MRead[0]);
end;

procedure FeyraMatrix.SetNumRows(NumRows:integer);
begin
  SetLength(MRead, NumRows);
end;

procedure FeyraMatrix.SetNumColumns(NumColumns:integer);
var
  i:integer;
begin
  for i := 0 to Rows-1 do SetLength(MRead[i], NumColumns);
end;

function FeyraMatrix.GetCell(n,m: integer):variant;
begin
  GetCell := Self.MRead[n-1][m-1];
end;

procedure FeyraMatrix.SetCell(n,m: integer; Value: variant);
begin
  Self.MRead[n-1][m-1] := Value;
end;

procedure FeyraMatrix.SetDefaultValue(DefValue:variant);
var
  n, m: integer;
begin
  for n := 1 to Rows do
    for m := 1 to Columns do
      if ((Self[n,m] = DCell) or (Self[n,m] = 0)) and (Self[n,m]<>DefValue) then
        Self[n,m] := DefValue;
  DCell := DefValue;
end;

constructor FeyraIntMatrix.Create(h, w, def: integer);
begin
  Rows := h;
  Columns := w;
  DefCell := def;
end;

constructor FeyraStrMatrix.Create(h, w: integer; def: string);
begin
  Rows := h;
  Columns := w;
  DefCell := def;
end;

constructor FeyraCharMatrix.Create(h, w: integer; def: char);
begin
  Rows := h;
  Columns := w;
  DefCell := def;
end;

constructor FeyraBoolMatrix.Create(h, w: integer; def: boolean);
begin
  Rows := h;
  Columns := w;
  DefCell := def;
end;

constructor FeyraRealMatrix.Create(h, w: integer; def: real);
begin
  Rows := h;
  Columns := w;
  DefCell := def;
end;

end.

