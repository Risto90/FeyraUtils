unit FeyraList;

{$i feyraconf.inc}

interface

uses
  Classes;

type
  FList = class
    private
      type
        ListType = (I,R,S,C,B);
        ElementRecord = record
          case TypeList: ListType of
            I: (IntField:integer);
            R: (RealField:real);
            S: (StrField:shortstring);
            C: (CharField:char);
            B: (BoolField:boolean);
        end;
        ExtArr = Array of ElementRecord;
      var
        RecList: ExtArr;
    protected
      function GetNumElements:integer;
      procedure SetNumElements (NumElements:integer);
      function GetElement (index:integer):variant;
      procedure SetElement (index:integer; Value:variant);
      //function GetSub (first,last:integer):variant;
      //procedure SetSub (first,last:integer; Value:variant);
      procedure AddElement (Value:variant);
      procedure PushElement (Value:variant);
    public
      property Elements: integer read GetNumElements write SetNumElements;
      property Element[index:integer]: variant read GetElement write SetElement;default;
      property Add: variant write AddElement;
      property Push: variant write PushElement;
  end;

implementation

uses
  SysUtils, Variants;

function FList.GetNumElements:integer;
begin
  GetNumElements := length(RecList);
end;

procedure FList.SetNumElements (NumElements:integer);
begin
  SetLength(RecList, NumElements);
end;

function FList.GetElement (index:integer):variant;
begin
  index := index-1;
  case RecList[index].TypeList of
    I: GetElement := RecList[index].IntField;
    R: GetElement := RecList[index].RealField;
    S: GetElement := RecList[index].StrField;
    C: GetElement := RecList[index].CharField;
    B: GetElement := RecList[index].BoolField;
  end;
end;

procedure FList.SetElement (index:integer; Value:variant);
var
  ValueType: integer;
begin
  ValueType := VarType(Value) and VarTypeMask;
  index := index-1;
  case ValueType of
    //varEmpty     : typeString := 'varEmpty';
    //varNull      : typeString := 'varNull';
    varSmallInt  : RecList[index].TypeList := I;
    varShortInt  : RecList[index].TypeList := I;
    varInteger   : RecList[index].TypeList := I;
    varSingle    : RecList[index].TypeList := R;
    varDouble    : RecList[index].TypeList := R;
    //varDate      : typeString := 'varDate';
    //varError     : typeString := 'varError';
    varBoolean   : RecList[index].TypeList := B;
    //varVariant   : typeString := 'varVariant';
    //varUnknown   : typeString := 'varUnknown';
    varByte      : RecList[index].TypeList := I;
    varWord      : RecList[index].TypeList := I;
    varString    : RecList[index].TypeList := S;
  end;
  if (ValueType = varString) and (length(Value) = 1) then
    RecList[index].TypeList := C;
  case RecList[index].TypeList of
    I: RecList[index].IntField := Value;
    R: RecList[index].RealField := Value;
    S: RecList[index].StrField := Value;
    C: RecList[index].CharField := Value;
    B: RecList[index].BoolField := Value;
  end;
end;

//function FList.GetSub (first,last:integer):variant;
//begin
//
//end;
//
//procedure FList.SetSub (first,last:integer; Value:variant);
//begin
//
//end;

procedure FList.AddElement (Value:variant);
begin
  Elements := Elements+1;
  Self[Elements] := Value;
end;

procedure FList.PushElement (Value:variant);
begin

end;

end.

