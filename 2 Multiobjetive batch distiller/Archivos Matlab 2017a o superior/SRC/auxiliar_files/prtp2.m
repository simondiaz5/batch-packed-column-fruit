% Let Fi(X), i=1...n, are objective functions
% for minimization. 
% A point X* is said to be Pareto optimal one
% if there is no X such that Fi(X)<=Fi(X*) for 
% all i=1...n, with at least one strict inequality.
% A=prtp(B),
% B - m x n input matrix: B=
% [F1(X1) F2(X1) ... Fn(X1);
%  F1(X2) F2(X2) ... Fn(X2);
%  .......................
%  F1(Xm) F2(Xm) ... Fn(Xm)]
% A - an output matrix with rows which are Pareto
% points (rows) of input matrix B.
% [A,b]=prtp(B). b is a vector which contains serial
% numbers of matrix B Pareto points (rows).
% Example.
% B=[0 1 2; 1 2 3; 3 2 1; 4 0 2; 2 2 1;...
%    1 1 2; 2 1 1; 0 2 2];
% [A b]=prtp(B)
% A =
%      0     1     2
%      4     0     2
%      2     2     1
% b =
%      1     4     7
% by Ahmed  HASSAN (ahah432@yahoo.com) and 
%Maurel AZA-GNANDJI(my.lrichy@gmail.com)
%Date: 30-07-2015
function [A varargout]=prtp2(B)
A=[]; varargout{1}=[];
sz1=size(B,1);
jj=0; kk(sz1)=0;
c(sz1,size(B,2))=0;
for k=1:sz1
  j=k;
  ak=B(k,:); 
  bb = ones(sz1,1)*ak-B;
  bb(k,:) = '';  
  if any(bb'<0)
    jj=jj+1;
    c(jj,:)=ak;
    kk(jj)=j;
  end
end
if jj
  A=c(1:jj,:);
  varargout{1}=kk(1:jj);
else
  warning('Points:Pareto',...
    'There are no Pareto points. The result is an empty matrix.')

end

