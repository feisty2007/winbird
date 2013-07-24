unit WalkOption;

interface
uses
  Classes,Controls;

type
  TWalkOption=class
  private
    FIncludeSubDir: boolean;
    FIncludeBetweenTime: boolean;
    FOnlyListDir: boolean;
    FIncludeHiddenFile: boolean;
    FTreeView: Boolean;
    FIncldueSystemFile: boolean;
    FSubLevel: integer;
    FStartDate: TDate;
    FEndDate: TDate;
    procedure SetEndDate(const Value: TDate);
    procedure SetIncldueSystemFile(const Value: boolean);
    procedure SetIncludeBetweenTime(const Value: boolean);
    procedure SetIncludeHiddenFile(const Value: boolean);
    procedure SetIncludeSubDir(const Value: boolean);
    procedure SetOnlyListDir(const Value: boolean);
    procedure SetStartDate(const Value: TDate);
    procedure SetSubLevel(const Value: integer);
    procedure SetTreeView(const Value: Boolean);
  public
    property IncludeSubDir:boolean read FIncludeSubDir write SetIncludeSubDir;
    property SubLevel:integer read FSubLevel write SetSubLevel;
    property OnlyListDir:boolean read FOnlyListDir write SetOnlyListDir;
    property TreeView:Boolean read FTreeView write SetTreeView;
    property IncludeHiddenFile:boolean read FIncludeHiddenFile write SetIncludeHiddenFile;
    property IncldueSystemFile:boolean read FIncldueSystemFile write SetIncldueSystemFile;
    property IncludeBetweenTime:boolean read FIncludeBetweenTime write SetIncludeBetweenTime;
    property StartDate:TDate read FStartDate write SetStartDate;
    property EndDate:TDate read FEndDate write SetEndDate;
  end;

implementation

{ TWalkOption }

procedure TWalkOption.SetEndDate(const Value: TDate);
begin
  FEndDate := Value;
end;

procedure TWalkOption.SetIncldueSystemFile(const Value: boolean);
begin
  FIncldueSystemFile := Value;
end;

procedure TWalkOption.SetIncludeBetweenTime(const Value: boolean);
begin
  FIncludeBetweenTime := Value;
end;

procedure TWalkOption.SetIncludeHiddenFile(const Value: boolean);
begin
  FIncludeHiddenFile := Value;
end;

procedure TWalkOption.SetIncludeSubDir(const Value: boolean);
begin
  FIncludeSubDir := Value;
end;

procedure TWalkOption.SetOnlyListDir(const Value: boolean);
begin
  FOnlyListDir := Value;
end;

procedure TWalkOption.SetStartDate(const Value: TDate);
begin
  FStartDate := Value;
end;

procedure TWalkOption.SetSubLevel(const Value: integer);
begin
  FSubLevel := Value;
end;

procedure TWalkOption.SetTreeView(const Value: Boolean);
begin
  FTreeView := Value;
end;

end.
 