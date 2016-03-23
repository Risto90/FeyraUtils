unit FeyraDynType;

{$i feyraconf.inc}

interface

uses
  Classes
  {$IFDEF USE_BGRABITMAP}, BGRABitmap, BGRABitmapTypes{$ENDIF};

type
  FDType = class
    private
      type
        ListType = set of (dtI,dtR,dtS,dtC,dtB,dtP,dtMN,dtUCP,dtTPX,dtRGB);
        DynRecord = record
          DataType: ListType;
          RawData: Array of byte;
        end;
      var
        Data: DynRecord;
    protected
      function DecodeString:AnsiString;
      function DecodeString:UnicodeString;
      procedure EncodeString(Value: AnsiString);
      procedure EncodeString(Value: UnicodeString);
      function DecodeChar:char;
      function DecodeChar:WideChar;
      procedure EncodeChar(Value: char);
      procedure EncodeChar(Value: WideChar);
      function AssembleInt:longint;
      function AssembleDouble:double;
      procedure DisassembleInt(Value: longint);
      procedure DisassembleDouble(Value: double);
      function GetBool:boolean;
      procedure SetBool(Value: boolean);
    public
      property Str: AnsiString read DecodeString write EncodeString;
      property UStr: UnicodeString read DecodeString write EncodeString;
      property AChar: char read DecodeChar write EncodeChar;
      property UChar: WideChar read DecodeChar write EncodeChar;
      property Int: longint read AssembleInt write DisassembleInt;
      property Float: double read AssembleDouble write DisassembleDouble;
      property Bool: boolean read GetBool write SetBool;
      {$IFDEF USE_BGRABITMAP}
      property Pixel: Array of byte read DecodeChar write EncodeChar;
      {$ENDIF}
  end;

implementation

uses
  SysUtils, Variants;

function FDType.DecodeString:AnsiString;
var
  ResStr: AnsiString;
  i,l: longint;
begin
  l := length(Data.RawData);
  for i := 0 to l-1 do ResStr := ResStr + AnsiChar(Data.RawData[i]);
  DecodeString := ResStr;
end;

function FDType.DecodeString:UnicodeString;
var
  ResStr: UnicodeString;
  i,l: longint;
begin
  l := length(Data.RawData);
  i := 0;
  while i<l do begin
    ResStr := ResStr + UnicodeChar(Data.RawData[i]*256*256+Data.RawData[i+1]*256+Data.RawData[i+2]);
    inc(i,3);
  end;
  DecodeString := ResStr;
end;

procedure FDType.EncodeString(Value: AnsiString);
var
  i,l: longint;
begin
  l := length(Value);
  SetLength(Data.RawData, l);
  for i := 0 to l-1 do Data.RawData[i] := Ord(Value[i+1]);
end;

procedure FDType.EncodeString(Value: UnicodeString);
var
  i,l,chone,chtwo: longint;
begin
  l := length(Value);
  SetLength(Data.RawData, l*3);
  i := 0;
  while i<l do begin
    chone := Ord(Value[i+1]);
    if chone>255 then begin
      Data.RawData[i+2] := chone mod 256;
      chtwo := chone div 256;
      if chtwo>255 then begin
        Data.RawData[i] := chtwo div 256;
        Data.RawData[i+1] := chtwo mod 256;
      end
      else begin
        Data.RawData[i] := 0;
        Data.RawData[i+1] := chtwo;
      end
    end
    else begin
      Data.RawData[i] := 0;
      Data.RawData[i+1] := 0;
      Data.RawData[i+2] := chone;
    end;
    inc(i,3);
  end;
end;

function FDType.DecodeChar:char;
begin
  DecodeChar := AnsiChar(Data.RawData[0]);
end;

function FDType.DecodeChar:WideChar;
begin
  DecodeChar := UnicodeChar(Data.RawData[0]*256*256+Data.RawData[1]*256+Data.RawData[2]);
end;

procedure FDType.EncodeChar(Value: char);
begin
  SetLength(Data.RawData, 1);
  Data.RawData[0] := Ord(Value);
end;

procedure FDType.EncodeChar(Value: WideChar);
var
  chone,chtwo: longint;
begin
  SetLength(Data.RawData, 3);
  chone := Ord(Value);
  if chone>255 then begin
    Data.RawData[2] := chone mod 256;
    chtwo := chone div 256;
    if chtwo>255 then begin
      Data.RawData[0] := chtwo div 256;
      Data.RawData[1] := chtwo mod 256;
    end
    else begin
      Data.RawData[0] := 0;
      Data.RawData[1] := chtwo;
    end
  end
  else begin
    Data.RawData[0] := 0;
    Data.RawData[1] := 0;
    Data.RawData[2] := chone;
  end;
end;

function FDType.AssembleInt:longint;
begin

end;

function FDType.AssembleDouble:double;
begin

end;

procedure FDType.DisassembleInt(Value: longint);
begin

end;

procedure FDType.DisassembleDouble(Value: double);
begin

end;

function FDType.GetBool:boolean;
begin

end;

procedure FDType.SetBool(Value: boolean);
begin

end;

end.

