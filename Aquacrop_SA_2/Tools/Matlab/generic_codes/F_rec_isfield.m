function v_flag = F_rec_isfield(vs_var, vc_fields)
%F_REC_ISFIELD  isfield recursif : pour tester si un champ et tous ses parents sont presents dans une structure.
%   v_flag = F_rec_isfield(vc_fields)   
%  
%   ENTREE(S): 
%      - vs_var : structure de donnee dont on veut tester si elle contient
%      la suite de champs definis par vc_fields
%      - vc_fields : cell contenant une famille ordonnee de nom de champs
%      dont on veut tester l'existence dans vs_var.
%  
%   SORTIE(S): descriptif des arguments de sortie
%      - v_flag : 1 si vs_var.vc_fields{1}.vc_fields{2}. ... .vc_fields{end} existe
%                 0 sinon. 
%
%  
%  AUTEUR(S): S. Buis
%  DATE: 12-Nov-2010
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-06-19 14:28:06 +0200 (mer., 19 juin 2013) $
%    $Author: plecharpent $
%    $Revision: 940 $
%  
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

count=1;
v_flag=1;
vs_var_long=vs_var;
while count<=length(vc_fields) && v_flag==1
    v_flag=isfield(vs_var_long,vc_fields{count});
    if v_flag, vs_var_long=vs_var_long.(vc_fields{count}); end
    count=count+1;
end
