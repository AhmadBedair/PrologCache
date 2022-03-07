%------General_predicates


len([],0).
len([_|T],N):-
	len(T,N1),
	N is N1 +1.


convertBinToDec(0,0).
convertBinToDec(X,Y):- X > 0, X1 is X//10, X2 is X mod 2,
	helper(X1,0,Y1),
	Y is Y1 + X2.
helper(0,_,0).
helper(X,Z,Y):- X>0,
	X1 is X mod 2,
	X2 is X // 10,
	Z1 is Z+1,
	helper(X2,Z1,Y1),
	Y is Y1 + X1*(2^Z1).
	
	
replaceIthItem(_,[],_,[]).
replaceIthItem(Item,List,I,Result):-
	len(List,N), N > I,
	replaceIthItemHelper(Item,List,I,Result).
replaceIthItemHelper(X,[_|T1],0,[X|T1]).
replaceIthItemHelper(X,[X1|T1],I,[X1|Z]):-
	I1 is I-1,
	replaceIthItemHelper(X,T1,I1,Z).
	
	

	

splitEvery(_,[],[]).
splitEvery(N,L,[Res1|Res2]):-
	L = [_|_],
	splitHelper2(N,L,Res1),
	rem(N,L,NewList),
	splitEvery(N,NewList,Res2).
	
	

%places the first N elements of a list into a new list.
	
splitHelper2(_,[],[]).
splitHelper2(0,_,[]).
splitHelper2(N,[H|T],[H|Res]):- N>0,
	N1 is N -1,
	splitHelper2(N1,T,Res).
	
%removes N elements from a list.
	
rem(0,[H|T],[H|T]).
rem(0,[],[]).
rem(N,[_|T],T1):- N>0,
	N1 is N-1,
	rem(N1,T,T1).
	
	
	
	
logBase2(1,0).
logBase2(Num,Res):- Num >1,
	N1 is Num//2,
	logBase2(N1,Res2),
	Res is Res2+1.
	
	
	
	
getNumBits(_,fullyAssoc,_,BitsNum):- BitsNum = 0.
getNumBits(Sets,setAssoc,_,BitsNum):- 0 is Sets mod 2, logBase2(Sets,BitsNum).
getNumBits(Sets,setAssoc,_,BitsNum):- \+(0 is Sets mod 2),increment(Sets,N) , logBase2(N,BitsNum).
getNumBits(_,directMap,Cache,R2):-
	len(Cache,L),
	increment(L,R1),
	logBase2(R1,R2).
	
	
% N is the length of the Cache in directMap (if N mod 2 not equal zero we want to increment it by 1 to get a value larger than it which is R and R mod 2 = 0).
% dih kanet moshkelet en lw 3awzeen ne3mel logbase2 le 7aga we tetla3 decimal.
increment(N,N):-0 is N mod 2 .
increment(N,R):- \+(0 is N mod 2), 
	N1 is N +1,
	increment(N1,R).


fillZeros(S,0,S).

fillZeros(S,N,Z):-N>0,
	N1 is N -1,
	string_concat("0",S,S1),
	fillZeros(S1,N1,Z).
	
string_length("",0).
string_length(S,N):-
	string_length(S1,1),
	string_concat(S1,S2,S),
	string_length(S2,N1),
	N is N1 +1.
	
removeFromString(S,0,S).
removeFromString(S,N,Z):-
	atom_number(S,Num),
	removeFromStringHelper(Num,N,Z).

removeFromStringHelper(0,N,0):- N>0.
removeFromStringHelper(Num,0,Num).
removeFromStringHelper(Num,N,R):-N>0,
		Num1 is Num//10,
		N1 is N -1,
		removeFromStringHelper(Num1,N1,R).
	
	
	
	%--------------Fully Associative
getDataFromCache(StringAddress,[item(tag(X),data(Y),ValidBit,_)|T],Y,0,fullyAssoc,_):-
  length([item(tag(X),data(Y),_,_)|T],N),
    N>0,
    ValidBit\=0,
	atom_number(StringAddress,Num1),
	atom_number(X,Num2),
	Num2 = Num1.
getDataFromCache(StringAddress,[item(tag(X),data(Y),_,_)|T],Data,Hops,fullyAssoc,_):-length([item(tag(X),data(Y),_,_)|T],N),N>0,
	atom_number(StringAddress,Num1),
	atom_number(X,Num2),
	(Num2 \= Num1),
	getDataFromCache(StringAddress,T,Data,Hops1,fullyAssoc,_),
	Hops is Hops1 + 1.
	
	convertAddress(Tag,_,Tag,_,fullyAssoc).
  
   get1stIn([item(_,_,_,0)|_],0).  
   	get1stIn([item(_,_,_,Order)|T],Index):-
	Order \=0,
	get1stIn(T,Index1),
	Index is Index1 + 1 .
	
	
	replace1stIn(OldCache,NewCache,ItemData,ResTag):-  		  
  get1stIn(OldCache,I),
  replaceIthItem(item(tag(ResTag),data(ItemData),1,0),OldCache,I,NewCache).

	
	
	
    get1zero([item(_,_,0,_)|_],0).  
   get1zero([item(_,_,1,_)|T],Index):-
          get1zero(T,Index1),
          Index is Index1 + 1 .	
  
  replaceif0(OldCache,NewCache,ItemData,ResTag):-  		  
  get1zero(OldCache,I),
  replaceIthItem(item(tag(ResTag),data(ItemData),1,0),OldCache,I,NewCache).

  
  replaceInCache(Tag,_,Mem,OldCache,NewCache,ItemData,fullyAssoc,_):-
  atom_chars(Tag,Taglist),
  length(Taglist,LenT),
  ExtendTag is 6 -LenT,
  fillZeros(Tag,ExtendTag,ResTag),
  convertBinToDec(Tag,Location),
  nth0(Location,Mem,ItemData),
  replaceif0(OldCache,NewCache,ItemData,ResTag).
  
  replaceInCache(Tag,_,Mem,OldCache,NewCache,ItemData,fullyAssoc,_):-
  atom_chars(Tag,Taglist),
  length(Taglist,LenT),
  ExtendTag is 6 -LenT,
  fillZeros(Tag,ExtendTag,ResTag),
  convertBinToDec(Tag,Location),
  nth0(Location,Mem,ItemData),
  replace1stIn(OldCache,NewCache,ItemData,ResTag).
  
  
	
	
	%--------------DirectMap
getDataFromCache(StringAddress,Cache,Y,0,directMap,Bits):-
	atom_number(StringAddress,Num),
	convertAddress(Num,Bits,Tag,Idx,directMap),
	convertBinToDec(Tag,Num1),
	convertBinToDec(Idx,Index),
	nth0(Index,Cache,X1),
	X1 = item(tag(X),data(Y),ValidBit,_),
	ValidBit\=0,
	atom_number(X,XNum),
	convertBinToDec(XNum,Num2),
	Num1 = Num2.
	
	convertAddress(Address,0,Address,"",directMap).
convertAddress(Address,Bits,Tag,Idx,directMap):-
   Bits>0,
   X is Address mod 10,
   Address1 is Address//10,
   Bits1 is Bits - 1,
   convertAddress(Address1,Bits1,Tag,Idx1,directMap),
   string_concat(Idx1,X,Res),
   atom_number(Res, Idx).
   
   convertAddress1(Address,Bits,Tag,Idx,directMap):-
       Idx is  Address mod (10^Bits),
	   Tag is (Address //(10^Bits)).
	   
	   getAddress(Idx,Tag,Address,Numbits,ResTag1):-
  atom_chars(Idx,Idxlist),
  length(Idxlist,LenI),
  ExtendIdx is Numbits -LenI,
  fillZeros(Idx,ExtendIdx,ResIdx),
  atom_chars(Tag,Taglist),
  length(Taglist,LenT),
  Sizetag is 6 - Numbits,
  ExtendTag is Sizetag - LenT,
  fillZeros(Tag,ExtendTag,ResTag),
  string_concat("",ResTag,ResTag1),
  string_concat("",ResIdx,ResIdx1),
  string_concat(ResTag1,ResIdx1,Address).
  
  
  replaceInCache(Tag,Idx,Mem,OldCache,NewCache,ItemData,directMap,BitsNum):-
   getAddress(Idx,Tag,Address1,BitsNum,TagString),
   atom_number(Address1,Address),
   convertBinToDec(Address,Location),
   nth0(Location,Mem,ItemData),
   convertBinToDec(Idx,Index),
   X= item(tag(TagString), data(ItemData), 1, 0),
   replaceIthItem(X,OldCache,Index,NewCache).
   
	
	%-------------setAssociative [item(tag(X),data(Y),ValidBit,_)|T]
	
getDataFromCache(StringAddress,Cache,Data,Index,setAssoc,SetsNum):-
	len(Cache,Length),
	atom_number(StringAddress,Num),
	convertAddress(Num,SetsNum,Tag,Idx,setAssoc),
	convertBinToDec(Idx,Index),
	L1 is Length//SetsNum,
	L2 is L1*Index,
	checkTag(Tag,Cache,L2,L1,Data).
	
checkTag(X,Cache,N1,N2,Data):- nth0(N1,Cache,item(tag(Z),data(Data),ValidBit,_)),ValidBit=1,N2>0,
	atom_number(Z,Z1),
	Z1 = X.
checkTag(X,Cache,N1,N2,Data):-nth0(N1,Cache,item(tag(Z),_,ValidBit,_)),N2>0,
	N3 is N2 -1,
	N4 is N1 +1,
	atom_number(Z,Z1),
	(X \= Z1;ValidBit = 0),
	checkTag(X,Cache,N4,N3,Data).

	
	
	getDataFromCache1(StringAddress,Cache,Data,HopsNum,setAssoc,SetsNum):-
	length(Cache,Length),
	Split  is  Length // SetsNum,
	splitEvery(Split,Cache,Res),
	atom_number(StringAddress,Address),
	convertAddress(Address,SetsNum,Tag,Idx,setAssoc),
	convertBinToDec(Idx,Set),
	nth0(Set,Res,Block),
	atom_number(TagString,Tag),
	getDataFromCache(TagString,Block,Data,HopsNum,fullyAssoc,_).
	
	
	
	
convertAddress(Bin,SetsNum,Tag,Idx,setAssoc):-
	logBase2(SetsNum,R1),
	Tag is Bin //(10^R1),
	Idx is Bin mod (10^R1).
	
   

   
	
getData(StringAddress,OldCache,_,NewCache,Data,HopsNum,Type,BitsNum,hit):-
getDataFromCache(StringAddress,OldCache,Data,HopsNum,Type,BitsNum),
NewCache = OldCache.
getData(StringAddress,OldCache,Mem,NewCache,Data,HopsNum,Type,BitsNum,miss):-
\+getDataFromCache(StringAddress,OldCache,Data,HopsNum,Type,BitsNum),
atom_number(StringAddress,Address),
convertAddress(Address,BitsNum,Tag,Idx,Type),
replaceInCache(Tag,Idx,Mem,OldCache,NewCache,Data,Type,BitsNum).



runProgram([],OldCache,_,OldCache,[],[],_,_).
runProgram([Address|AdressList],OldCache,Mem,FinalCache,
[Data|OutputDataList],[Status|StatusList],Type,NumOfSets):-
getNumBits(NumOfSets,Type,OldCache,BitsNum),
getData(Address,OldCache,Mem,NewCache,Data,HopsNum,Type,BitsNum,Status),
runProgram(AdressList,NewCache,Mem,FinalCache,OutputDataList,StatusList,Type,NumOfSets).

replaceInCache(Tag,Idx,Mem,OldCache,NewCache,ItemData,setAssoc,SetsNum):-
    logBase2(SetsNum,BitsNum),
	getAddress(Idx,Tag,Address1,BitsNum,TagString),
	atom_number(Address1,Address),
   convertBinToDec(Address,Location),
   nth0(Location,Mem,ItemData),
    length(OldCache,Length),
	Split  is  Length // SetsNum,
	splitEvery(Split,OldCache,Res),
	convertBinToDec(Idx,Set),
	nth0(Set,Res,Block),
	replaceif0(Block,NewCache1,ItemData,TagString),
	replaceIthItem(NewCache1,Res,Set,Cache1),
    splitEvery(Split,NewCache,Cache1).	
	
	replaceInCache(Tag,Idx,Mem,OldCache,NewCache,ItemData,setAssoc,SetsNum):-
    logBase2(SetsNum,BitsNum),
	getAddress(Idx,Tag,Address1,BitsNum,TagString),
	atom_number(Address1,Address),
   convertBinToDec(Address,Location),
   nth0(Location,Mem,ItemData),
    length(OldCache,Length),
	Split  is  Length // SetsNum,
	splitEvery(Split,OldCache,Res),
	convertBinToDec(Idx,Set),
	nth0(Set,Res,Block),
	replace1stIn(OldCache,NewCache,ItemData,TagString),
	replaceIthItem(NewCache1,Res,Set,Cache1),
    splitEvery(Split,NewCache,Cache1).	
	
	 


	


	
	



	
	
	
	
	

	
	



	



	