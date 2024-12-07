function [v_head_lines,v_file_name] = F_sl_func_tpl(v_function_name)
%F_SL_FUNC_TPL  Production d'un en-tete de fonction MSLIB
%   [v_head_lines,v_file_name] = F_sl_func_tpl(v_function_name)   
%  
%   ENTREE(S):
%      - v_function_name : nom de la nouvelle fonction a creer
%      
%   SORTIE(S):
%      - v_head_lines (cell de strings): lignes d'en-tete de la fonction (definition et
%      lignes d'aide) formatees et personnalisees
%      - v_file_name : nom de la fonction a creer
%  
%   CONTENU:
%     - le nom reel de la fonction est prefixe par convention avec 'F_'  
%     pour le travail sur MultiSimLib
%     - des informations personnalisees dans les lignes produites: la ligne de 
%     definition de la fonction, le debut de la ligne de description, le
%     nom de l'auteur, la date de creation du fichier. 
%
%   APPEL(S): 
%      - 
%  
%   EXEMPLE(S): 
%      - [lignes,nom_fichier] = F_sl_func_tpl('NomFonction')
%  
%  AUTEUR(S): P. Lecharpentier
%  DATE: 27-Nov-2006
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-06-19 14:49:50 +0200 (mer., 19 juin 2013) $
%    $Author: plecharpent $
%    $Revision: 40 $
%  
%  
% See also F_sl_new_func
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% declaration des auteurs
authors.lecharpe='P. Lecharpentier';
authors.pcl='P. Clastre';
authors.sbuis='S. Buis';
authors.hvvarella='H. V. Varella';
% prefixage des fonctions
v_prefix='F_'; % fixe pour l'instant...par convention dans le projet
% recuperation du login 
[v_ret,v_login_str]=dos('echo %username%');
clear v_ret;
% on enleve ce qui n est pas lettre (ici il y a un retour charriot dans
% v_login_str) pour creer le v_user_name
v_login_str=v_login_str(isletter(v_login_str));
if ismember(v_login_str,fieldnames(authors))
    % recuperation du nom si v_login_str est un champ de authors
    v_username=authors.(v_login_str);
else
    v_username='Nom inconnu';
end
% definition du nom du fichier
v_file_name=[v_prefix v_function_name '.m'];
%
% v_head_lines={sprintf('function output = %s%s(input)',v_prefix,v_function_name)};
% v_head_lines{2}=[ '%F_' upper(v_function_name) '  One line description of the function here'];
% v_head_lines{3}=['%  ' sprintf(' output_args = F_%s(input_args)   Write here detailed input/ouput arguments list',v_function_name)];
% v_head_lines{4}='%  ';
% v_head_lines{5}='%   INPUT(S): input arguments decription';
% v_head_lines{6}='%      - ';
% v_head_lines{7}='%  ';
% v_head_lines{8}='%   OUTPUT(S): output arguments decription';
% v_head_lines{9}='%      - ';
% v_head_lines{10}='%  ';
% v_head_lines{11}='%   CONTENT: function description';
% v_head_lines{12}='%  ';
% v_head_lines{13}='%   CALLS: list of the called functions';
% v_head_lines{14}='%      - ';
% v_head_lines{15}='%  ';
% v_head_lines{16}='%   EXAMPLE(S): list of function uses';
% v_head_lines{17}='%      - ';
% v_head_lines{18}='%  ';
% v_head_lines{19}=['%  ' sprintf('AUTHOR(S): %s',v_username)];
% v_head_lines{20}=['%  DATE: ' date];
% v_head_lines{21}='%  VERSION: 0';
% v_head_lines{22}='%  ';
% v_head_lines{23}='%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%';

v_head_lines={sprintf('function sorties = %s%s(entrees)',v_prefix,v_function_name)};
v_head_lines{2}=[ '% Description d''une ligne MAXI a placer ici'];
%v_head_lines{2}=[ '%F_' upper(v_function_name) '  Description d''une ligne a placer ici'];
v_head_lines{3}=[ '% '];
v_head_lines{4}=[ '% Description plus detaillee a placer ici'];
%v_head_lines{3}=['%  ' sprintf(' args_sortie = F_%s(args_entree)   Liste detaillee les arguments d''entree/sortie',v_function_name)];
v_head_lines{5}='%  ';
v_head_lines{6}='%   ENTREE(S): ';
v_head_lines{7}='%      - argin1 :';
v_head_lines{8}='%            description du premier argument d''entree ...';
v_head_lines{9}='%  ';
v_head_lines{10}='%   SORTIE(S): ';
v_head_lines{11}='%      - argout2 :';
v_head_lines{12}='%            description du premier argument de sortie ...';
v_head_lines{13}='%  ';
v_head_lines{14}='%   CONTENU: ';
v_head_lines{15}='%      descriptif des etapes de l''algorithme';
v_head_lines{16}='%  ';
v_head_lines{17}='%   APPEL(S): liste des fonctions appelees';
v_head_lines{18}='%      - ';
v_head_lines{19}='%  ';
v_head_lines{20}='%   EXEMPLE(S): cas d''utilisation de la fonction';
v_head_lines{21}='%      - ';
v_head_lines{22}='%  ';
v_head_lines{23}=['%  ' sprintf('AUTEUR(S): %s',v_username)];
v_head_lines{24}=['%  DATE: ' date];
v_head_lines{25}='%  VERSION: 0';
v_head_lines{26}='%  ';
v_head_lines{27}='%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%';
%
