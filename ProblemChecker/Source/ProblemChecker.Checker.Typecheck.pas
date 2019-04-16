namespace ProHolz.SourceChecker;

interface
uses ProHolz.Ast;
type

  TProblem_VarTypes = class( ISingleProbSolver)
  protected
   method isProblemType(const master, node : TSyntaxNode; out varname : String ) : Boolean;
 public
   method CheckForProblem(const syntaxTree: TSyntaxNode; NodeSolver : ISyntaxNodeSolver; ProblemLog : IProblem_Log): Boolean; virtual;
   property CheckTyp : eEleCheck read eEleCheck.eVarsWithTypes; virtual;
 end;


  TProblem_TypeInTypes = class(TProblem_VarTypes, ISingleProbSolver)
  public
    method CheckForProblem(const syntaxTree: TSyntaxNode; NodeSolver : ISyntaxNodeSolver; ProblemLog : IProblem_Log): Boolean; override;
    property CheckTyp : eEleCheck read eEleCheck.eTypeinType; override;
  end;

implementation


method TProblem_VarTypes.isProblemType(const master, node: TSyntaxnode; out varname : String ): Boolean;
begin
  Var lnode := node;
  case lnode.AttribType.ToLower of
    'array' : begin

              // here we  check for the finalType of a Array
      loop  begin
        var lnodetemp := lnode.FindNode(TSyntaxNodeType.ntType);
        if not assigned(lnodetemp) then break;
        lnode := lnodetemp;
        if not node.AttribType.ToLower.Equals('array') then
          break;
      end;
      if lnode.HasChildren then
      begin
        varname := master.FindNode(TSyntaxNodeType.ntName):AttribName;
        result := true;
      end;
    end;
    else
      begin
        varname := master.FindNode(TSyntaxNodeType.ntName):AttribName;
        result := true;
      end;
  end;
end;

method TProblem_VarTypes.CheckForProblem(const syntaxTree: TSyntaxNode; NodeSolver: ISyntaxNodeSolver; ProblemLog: IProblem_Log): Boolean;
begin
  result := false;
  var Nodes := syntaxTree.FindAllNodes(SNT.ntVariable);

  if Nodes:Count > 0 then
  begin
    for each child in Nodes do
      begin
      var lnode := child.FindNode(TSyntaxNodeType.ntType);
      if assigned (lnode) and lnode.HasChildren then
      begin
           // Allow Array Types
        if (lnode.AttribType <> '') {and (lnode.AttribType.ToLower <> 'array')} then
        begin
          var varname : String;
          if isProblemType(child, lnode, out varname) then
          begin
            ProblemLog.Problem_At(CheckTyp, child.Line, child.Col, varname);
            result := true;
          end;
        end;
      end;
    end;
  end;
end;


method TProblem_TypeInTypes.CheckForProblem(const syntaxTree: TSyntaxNode; NodeSolver: ISyntaxNodeSolver; ProblemLog: IProblem_Log): Boolean;
begin
  result := false;
  var Nodes := syntaxTree.FindAllNodes(SNT.ntTypeDecl);

  if Nodes:Count > 0 then
  begin
    for each child in Nodes do
      begin
      var lnode := child.FindNode(TSyntaxNodeType.ntType);
      if assigned (lnode) and lnode.HasChildren then
      begin
          // Allow Array Types
        if (lnode.AttribType <> '') {and (lnode.AttribType.ToLower <> 'array')} then
        begin
          case lnode.AttribType.ToLower of
            'record' : begin
            if lnode.HasChildren then
              begin
                var varname : String;
                {$IF LOG}
                //writeLn;
               //// writeLn($" ***** {varname} *****");
                //writeLn(TSyntaxTreeWriter.ToXML(lnode, true));
                //writeLn;
               //// writeLn($" ===== End ***** {varname} *****");
                writeLn;
               {$ENDIF}

                for each field in lnode.ChildNodes do
                 begin
                  var lType := field.FindNode(TSyntaxNodeType.ntType);
                  if assigned(lType) then
                  if (lType.AttribType <> '') then
                  if isProblemType(field, lType, out varname) then
                  begin
                    ProblemLog.Problem_At(CheckTyp, lnode.Line, lnode.Col, varname);
                    result := true;
                  end;
                 end;
              end;
            end;
            'class' : begin
              if lnode.HasChildren then
              begin
                var varname : String;
               {$IF LOG}
               writeLn;
               writeLn(TSyntaxTreeWriter.ToXML(lnode, true));
               writeLn;
              {$ENDIF}

                for each field in lnode.ChildNodes do
                  begin
                  var lType := field.FindNode(TSyntaxNodeType.ntType);
                 if assigned(lType) then
                   if (lType.AttribType <> '') then
                     if isProblemType(field, lType, out varname) then
                     begin
                       ProblemLog.Problem_At(CheckTyp, lnode.Line, lnode.Col, varname);
                       result := true;
                     end;

                 if field.GetAttribute(TAttributeName.anVisibility) <> '' then
                  begin
                    for each lfield  in field.ChildNodes do
                     begin
                       lType := lfield.FindNode(TSyntaxNodeType.ntType);
                      if assigned(lType) then
                        if (lType.AttribType <> '') then
                          if isProblemType(lfield, lType, out varname) then
                          begin
                            ProblemLog.Problem_At(CheckTyp, lnode.Line, lnode.Col, varname);
                            result := true;
                          end;
                     end;
                  end;

               end;


              end;
            end;


            else
              begin
               //{$IF LOG}
               //writeLn(TSyntaxTreeWriter.ToXML(lnode, true));
               //writeLn('==========================');
               //writeLn;
               //{$ENDIF}
              //  ProblemLog.Problem_At(CheckTyp, child.Line, child.Col, child.FindNode(TSyntaxNodeType.ntName).AttribName);
              // result := true;
              end;
          end;
        end;
      end;
    end;
  end;
end;

end.