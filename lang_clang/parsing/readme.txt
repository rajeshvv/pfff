-*- org -*-

* Introduction

This directory is a thin wrapper around 'clang-check --ast-dump' to
make available clang AST to OCaml. See also pfff/lang_cpp/,
pfff/lang_c/. pfff/lang_objc/ which use a C/cpp/C++/ObjectiveC parser
written from scratch.

To be able to start writing analysis in OCaml of C/C++/... code, you
first need to install a 'clang-check' that actually works. Follow the
instructions here:
http://clang.llvm.org/docs/LibASTMatchersTutorial.html
Note that the clang in macport doesn't have clang-check.
Moreover clang-3.2 has a version of clang-check that does not print
everything as a sexp (e.g. typedefs are not a sexp) which makes
parsing harder. clang-git seems to be good, but the dumper was evolved,
and so prefer an old version, e8d411997899a87e1a9f63ad3f52b38e7931687c^

* Statistics

Here are some statistics on the AST "constructors" of clang for different
projects:

** chipmunk

EnumConstantDecl: 732891
IntegerLiteral: 630268
FunctionDecl: 363423
FieldDecl: 296325
DeclRefExpr: 259985
ImplicitCastExpr: 226656
TypedefDecl: 182428
UnaryOperator: 162965
VarDecl: 133737
VisibilityAttr: 131977
BinaryOperator: 127322
CharacterLiteral: 114986
EnumDecl: 87698
DeprecatedAttr: 86672
RecordDecl: 73602
ParenExpr: 50089
CompoundStmt: 42935
CallExpr: 39641
CStyleCastExpr: 38940
ReturnStmt: 35516
MemberExpr: 35280
TextComment: 33876
MaxFieldAlignmentAttr: 28350
AlwaysInlineAttr: 24840
ParagraphComment: 23314
FullComment: 22062
NoDebugAttr: 21762
__Null__: 10723
StringLiteral: 9505
ConstAttr: 8424
DeclStmt: 7530
InlineCommandComment: 5709
IfStmt: 5269
NoThrowAttr: 5244
NonNullAttr: 4860
ArraySubscriptExpr: 4238
FloatingLiteral: 3912
InitListExpr: 3578
AsmLabelAttr: 3402
PackedAttr: 2808
CompoundLiteralExpr: 2268
FormatAttr: 2109
AlignedAttr: 1782
ConditionalOperator: 1577
ShuffleVectorExpr: 1350
WarnUnusedResultAttr: 1350
UnaryExprOrTypeTraitExpr: 1201
VerbatimLineComment: 1143
MayAliasAttr: 972
CompoundAssignOperator: 705
PureAttr: 540
NullStmt: 514
MallocAttr: 432
ReturnsTwiceAttr: 432
ForStmt: 284
UnusedAttr: 270
CaseStmt: 111
BlockCommandComment: 109
FormatArgAttr: 108
UnavailableAttr: 108
BreakStmt: 58
DefaultStmt: 55
SwitchStmt: 55
GCCAsmStmt: 54
TranslationUnitDecl: 54
TransparentUnionAttr: 54
ContinueStmt: 41
WhileStmt: 19
BlockDecl: 2
BlockExpr: 2
BlocksAttr: 2
ExprWithCleanups: 2
GotoStmt: 2
LabelStmt: 2
__Capture__: 2
__Cleanup__Block: 2
DoStmt: 1


** fbobjc

ParmVarDecl: 32566741
ObjCMethodDecl: 16219827
AvailabilityAttr: 10253605
FunctionDecl: 8505641
IntegerLiteral: 8218966
ImplicitCastExpr: 7061605
FieldDecl: 5845796
EnumConstantDecl: 5749762
DeclRefExpr: 4897687
VarDecl: 4514768
ObjCProtocol: 3345647
TypedefDecl: 3294225
ObjCIvarDecl: 3238766
ObjCPropertyDecl: 2990105
BinaryOperator: 2489588
ObjCInterfaceDecl: 2321054
__Super__ObjCInterface: 2135758
VisibilityAttr: 1759358
ParenExpr: 1549465
TextComment: 1172992
CFAuditedTransferAttr: 1136559
CompoundStmt: 1019308
RecordDecl: 964589
CallExpr: 929039
EnumDecl: 887208
OpaqueValueExpr: 873380
MemberExpr: 803855
UnaryOperator: 715413
ReturnStmt: 696039
LinkageSpecDecl: 659623
ObjCMessageExpr: 516085
ObjCInterface: 486279
ObjCCategoryDecl: 483513
CXXRecordDecl: 430408
__Null__: 423344
ConstAttr: 384629
CStyleCastExpr: 383663
ParagraphComment: 380244
ObjCProtocolDecl: 357688
CXXMethodDecl: 297042
DeclStmt: 285194
NoThrowAttr: 266124
FullComment: 249596
UnresolvedLookupExpr: 238709
__getter__ObjCMethod: 223994
NonNullAttr: 223834
NSReturnsRetainedAttr: 218248
PseudoObjectExpr: 217664
ObjCPropertyRefExpr: 215463
IfStmt: 207572
NSConsumesSelfAttr: 207269
AsmLabelAttr: 203803
CXXThisExpr: 201528
CXXDependentScopeMemberExpr: 199667
AlwaysInlineAttr: 199169
TemplateTypeParmDecl: 195633
CXXOperatorCallExpr: 190205
MaxFieldAlignmentAttr: 186039
CharacterLiteral: 180867
__ADL__: 173017
FormatAttr: 137944
StringLiteral: 136829
ObjCIvarRefExpr: 114422
__TemplateArgument__: 98075
ObjCStringLiteral: 97734
FunctionTemplateDecl: 85589
CXXConstructorDecl: 80377
FloatingLiteral: 74884
__Dots__: 74169
__NoADL__: 65692
UnavailableAttr: 64511
CXXConstructExpr: 64066
WarnUnusedResultAttr: 62175
ConditionalOperator: 61212
CXXBoolLiteralExpr: 58597
AccessSpecDecl: 48198
ArraySubscriptExpr: 47947
ImplicitParamDecl: 47390
DoStmt: 45955
__CXXCtorInitializer__Field: 44751
UsingShadowDecl: 43485
UsingDecl: 43411
InlineCommandComment: 41919
ParamCommandComment: 38290
ObjCBoolLiteralExpr: 37242
SentinelAttr: 37102
CXXUnresolvedConstructExpr: 35028
ExprWithCleanups: 34908
ObjCReturnsInnerPointerAttr: 34412
ClassTemplateSpecializationDecl: 34266
UnresolvedMemberExpr: 33104
GNUNullExpr: 31456
ParenListExpr: 29857
NullStmt: 28380
CompoundAssignOperator: 27061
ClassTemplateDecl: 26365
PureAttr: 24870
CXXDestructorDecl: 24314
__public__: 23863
MaterializeTemporaryExpr: 23543
ClassTemplateSpecialization: 23527
UnaryExprOrTypeTraitExpr: 21670
PredefinedExpr: 21484
WhileStmt: 20918
CXXStaticCastExpr: 20266
CXXMemberCallExpr: 19510
ReturnsTwiceAttr: 18377
MallocAttr: 18325
__Capture__: 16584
ForStmt: 16295
CFReturnsRetainedAttr: 16287
BlockCommandComment: 15202
NamespaceDecl: 14562
UnusedAttr: 14108
CaseStmt: 13525
__Original__Namespace: 12527
BreakStmt: 11267
DependentScopeDeclRefExpr: 10792
BlockDecl: 10107
CXXFunctionalCastExpr: 10008
InitListExpr: 8801
__SKIPPED__: 8491
FormatArgAttr: 7809
DeprecatedAttr: 7784
__CXXCtorInitializer__: 7627
CFConsumedAttr: 7375
ObjCEncodeExpr: 6747
ObjCProperty: 6687
ObjCPropertyImplDecl: 6687
BlockExpr: 6038
ObjCIvar: 5648
CXXCatchStmt: 5594
CXXTryStmt: 5593
FriendDecl: 5282
NSReturnsNotRetainedAttr: 5036
ArcWeakrefUnavailableAttr: 4916
ObjCRootClassAttr: 4916
__Instance__: 4251
__Cleanup__Block: 4161
SwitchStmt: 3992
FunctionTemplate: 3888
NonTypeTemplateParmDecl: 3802
DefaultStmt: 3649
AlignedAttr: 3448
UsingShadow: 3281
CXXTemporaryObjectExpr: 3269
CXXThrowExpr: 3135
TranslationUnitDecl: 3115
ObjCImplementation: 2948
NSConsumedAttr: 2902
CXXDeleteExpr: 2733
Function: 2660
ObjCSelectorExpr: 2567
CXXConstCastExpr: 2531
CXXNewExpr: 2497
ObjCImplementationDecl: 2495
ObjCExceptionAttr: 2458
ObjCSubscriptRefExpr: 2201
ClassTemplatePartialSpecializationDecl: 2127
TransparentUnionAttr: 2051
ObjCAtCatchStmt: 2022
ObjCAtTryStmt: 2000
CXXScalarValueInitExpr: 1899
ObjCBridgedCastExpr: 1545
ObjCForCollectionStmt: 1500
CXXReinterpretCastExpr: 1472
WeakImportAttr: 1438
ObjCRequiresPropertyDefsAttr: 1384
__setter__ObjCMethod: 1370
VerbatimBlockLineComment: 1224
CXXConversionDecl: 1203
CXXBindTemporaryExpr: 1196
CXXTemporary: 1196
ObjCArrayLiteral: 1077
ContinueStmt: 1035
VerbatimLineComment: 984
ObjCDictionaryLiteral: 946
CXXDefaultArgExpr: 930
BlocksAttr: 910
ObjCBoxedExpr: 875
UnresolvedUsingValueDecl: 861
StmtExpr: 814
PackedAttr: 735
CompoundLiteralExpr: 716
SubstNonTypeTemplateParmExpr: 586
AlignMac68kAttr: 567
ImplicitValueInitExpr: 498
UsingDirectiveDecl: 486
ObjCNSObjectAttr: 463
__virtual__: 450
CFReturnsNotRetainedAttr: 409
__Class__: 409
VerbatimBlockComment: 404
__protected__: 403
CXXPseudoDestructorExpr: 375
ObjCProtocolExpr: 346
HTMLEndTagComment: 344
HTMLStartTagComment: 344
BinaryConditionalOperator: 343
ObjCCategory: 275
ObjCCategoryImplDecl: 275
ObjCCategoryImpl: 261
Field: 260
GotoStmt: 239
ObjCAtSynchronizedStmt: 222
__CXXCtorInitializer__ObjCIvar: 204
ObjCIndirectCopyRestoreExpr: 188
IndirectFieldDecl: 130
ObjCAutoreleasePoolStmt: 63
LabelStmt: 62
IBOutletAttr: 60
IBActionAttr: 38
ObjCAtThrowStmt: 37
__private__: 19
VAArgExpr: 15
ConstructorAttr: 11
LabelDecl: 8
ObjCAtFinallyStmt: 7
GCCAsmStmt: 5
CXXTypeidExpr: 2
OffsetOfExpr: 2
Namespace: 1
NamespaceAliasDecl: 1
