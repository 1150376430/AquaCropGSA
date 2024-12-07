function vc_list = F_stringlist2cell(v_string_list,varargin)
%F_LISTSTR2CELL  Construction d'un cellstr avec les mots contenus dans une
% chaine de caracteres
%   vc_list = F_stringlist2cell(v_string_list)
%  
%   ENTREE(S): descriptif des arguments d'entree
%      - v_string_list: chaine de caracteres contenant une liste de mots
%      separes par des espaces ou de virgules (peut contenir des espaces)
%      ex: ' mot1  mot2        mot3  '
%          ' mot1,mot2,   mot3'
%      - optionnel
%         v_delim= delimiteur autre que espace , ',' , ex: ';
%
%    Le delimiter par defaut est l'espace, mais si la ',' est detectee
%    elle devient automatiquement le delimiter. 
%
%   SORTIE(S): descriptif des arguments de sortie
%      - vc_list : cellstr des mots de la chaine v_string_list
%  
%   CONTENU: descriptif de la fonction
%  
%   APPEL(S): liste des fonctions appelees
%      - 
%  
%   EXEMPLE(S): cas d'utilisation de la fonction
%      - F_stringlist2cell(' mot1  mot2        mot3  ')
%      - F_stringlist2cell(' mot1,mot2,   mot3')
%      - F_stringlist2cell(' mot1;mot2;   mot3',';')
%      vc_list = {'mot1';'mot2';'mot3'}
%  
%  AUTEUR(S): P. Lecharpentier
%  DATE: 29-Jul-2011
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-06-19 14:28:06 +0200 (mer., 19 juin 2013) $
%    $Author: plecharpent $
%    $Revision: 940 $
%  
%  
% See also F_deblank, regexprep,textscan
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% delimiter par defaut
v_delim=',';

if nargin>1
    v_delim=varargin{1};
end

vc_list={}; 
if ~all([ischar(v_string_list) ischar(v_delim)])
   
   if nargin>1
        F_disp('L''un des arguments n''est pas une chaine !');
   else
       F_disp('L''argument n''est pas une chaine !');
   end
   return
end

if isempty(v_string_list)
    return
end

% suppression des espaces debut/fin
v_labels=F_deblank(v_string_list);

if ~isempty(strfind(v_labels,v_delim)) && ~strcmp(v_delim,' ')
    % suppression des blancs
    v_labels=regexprep(v_labels,'['' '']*','');
else
    % remplacement des espaces par des ,
    v_labels=regexprep(v_labels,'['' '']*',v_delim);
end
vc_tmp=textscan(v_labels,'%s','delimiter',v_delim);
vc_list=vc_tmp{1};
