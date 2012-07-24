unit NiceExceptions;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  EArgumentUnassigned = class(Exception);

function GetFullExceptionInfo(const aException: Exception): string;

procedure AssertArgumentAssigned(const aObject: TObject; const aArgumentName: string); inline;
procedure AssertArgumentAssigned(const aObject: boolean; const aArgumentName: string); inline;

implementation

function GetFullExceptionInfo(const aException: Exception): string;
var
  FrameNumber, FrameCount: longint;
  Frames: PPointer;
begin
  result := '';
  result += 'Exception class: ' + aException.ClassName + LineEnding;
  result += 'Exception message: ' + aException.Message + LineEnding;
  if RaiseList = nil then
    exit;
  result += BackTraceStrFunc(RaiseList^.Addr) + LineEnding;
  FrameCount := RaiseList^.Framecount;
  Frames := RaiseList^.Frames;
  for FrameNumber := 0 to FrameCount - 1 do
    result += BackTraceStrFunc(Frames[FrameNumber]) + LineEnding;
  result += '(end of stack trace)';
end;

procedure AssertArgumentAssigned(const aObject: TObject; const aArgumentName: string);
begin
  AssertArgumentAssigned(Assigned(aObject), aArgumentName);
end;

procedure AssertArgumentAssigned(const aObject: boolean;
  const aArgumentName: string);
begin
  if not aObject then
    raise EArgumentUnassigned.Create(aArgumentName);
end;

end.
