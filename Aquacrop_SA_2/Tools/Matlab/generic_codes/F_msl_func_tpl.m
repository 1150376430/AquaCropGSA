function [v_head_lines,v_file_name] = F_msl_func_tpl(v_function_name,v_language)
% F_MSL_FUNC_TPL  Production d'un en-tete de fonction MSLIB
%   [v_head_lines,v_file_name] = F_msl_func_tpl(v_function_name,language)
%
%   ENTREE(S):
%      - v_function_name : nom de la nouvelle fonction a creer
%      - v_language: mot clef de la langue
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
%      - [lignes,nom_fichier] = F_msf_func_tpl('NomFonction')
%      - [lignes,nom_fichier] = F_msf_func_tpl('NomFonction','english')
%
%  AUTEUR(S): P. Lecharpentier
%  DATE: 27-Nov-2006
%
%  MODIFICATIONS (last commit)
%    $Date: 2013-04-18 14:51:29 +0200 (jeu., 18 avr. 2013) $
%    $Author: plecharpent $
%    $Revision: 851 $
%
% See also F_new_func
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vc_languages={'french','english'};

if nargin<2
    v_language='french';
end

if ~ ismember(vc_languages,v_language)
    F_disp([v_language ': this language is not defined or mispelled!']);
    return;
end

% prefixage des fonctions
v_prefix='F_'; % fixe pour l'instant...par convention dans le projet
% recuperation du login
if ispc
    v_login_str=getenv('username');
elseif isunix
    v_login_str=getenv('LOGNAME');
end
% on enleve ce qui n est pas lettre (ici il y a un retour charriot dans
% v_login_str) pour extraire vs_user
v_login_str=v_login_str(isletter(v_login_str));
vs_user=F_authors(v_login_str);

% definition du nom du fichier
v_file_name=[v_prefix v_function_name '.m'];
%
switch v_language
    case 'english'
        v_head_lines={sprintf('function output = %s%s(input)',v_prefix,v_function_name)};
        v_head_lines{2}=[ '%F_' upper(v_function_name) '  One description line goes here'];
        v_head_lines{3}=['%  ' sprintf(' output_args = F_%s(input_args)   Write here detailed input/ouput arguments list',v_function_name)];
        v_head_lines{4}='%  ';
        v_head_lines{5}='%   INPUT(S): input arguments description';
        v_head_lines{6}='%      - ';
        v_head_lines{7}='%  ';
        v_head_lines{8}='%   OUTPUT(S): output arguments description';
        v_head_lines{9}='%      - ';
        v_head_lines{10}='%  ';
        v_head_lines{11}='%   CONTENT: function description';
        v_head_lines{12}='%  ';
        v_head_lines{13}='%   CALLS: list of the called functions';
        v_head_lines{14}='%      - ';
        v_head_lines{15}='%  ';
        v_head_lines{16}='%   EXAMPLE(S): use(s) case(s) example(s)';
        v_head_lines{17}='%      - ';
        v_head_lines{18}='%  ';
        v_head_lines{19}=['%  ' sprintf('AUTHOR(S): %s',vs_user.(v_login_str))];
        v_head_lines{20}=['%  DATE: ' date];
        v_head_lines{21}='%';
        % v_head_lines{21}='%  VERSION: 0';
        v_head_lines{22}='%  ';
        v_head_lines{23}='%  MODIFICATIONS (last commit)';
        v_head_lines{24}='%    $Date: 2013-04-18 14:51:29 +0200 (jeu., 18 avr. 2013) $';
        v_head_lines{25}='%    $Author: plecharpent $';
        v_head_lines{26}='%    $Revision: 851 $';
        v_head_lines{27}='%  ';
        v_head_lines{28}='% See also F_name1,...(linked/called functions, if none, remove this line)';
        v_head_lines{29}='%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%';
        
        
    case 'french'
        v_head_lines={sprintf('function sorties = %s%s(entrees)',v_prefix,v_function_name)};
        v_head_lines{2}=[ '%F_' upper(v_function_name) '  Description d''une ligne a placer ici'];
        v_head_lines{3}=['%  ' sprintf(' args_sortie = F_%s(args_entree)   Liste detaillee les arguments d''entree/sortie',v_function_name)];
        v_head_lines{4}='%  ';
        v_head_lines{5}='%   ENTREE(S): descriptif des arguments d''entree';
        v_head_lines{6}='%      - ';
        v_head_lines{7}='%  ';
        v_head_lines{8}='%   SORTIE(S): descriptif des arguments de sortie';
        v_head_lines{9}='%      - ';
        v_head_lines{10}='%  ';
        v_head_lines{11}='%   CONTENU: descriptif de la fonction';
        v_head_lines{12}='%  ';
        v_head_lines{13}='%   APPEL(S): liste des fonctions appelees';
        v_head_lines{14}='%      - ';
        v_head_lines{15}='%  ';
        v_head_lines{16}='%   EXEMPLE(S): cas d''utilisation de la fonction';
        v_head_lines{17}='%      - ';
        v_head_lines{18}='%  ';
        %v_head_lines{19}=['%  ' sprintf('AUTEUR(S): %s',v_username)];
        v_head_lines{19}=['%  ' sprintf('AUTEUR(S): %s',vs_user.(v_login_str))];
        v_head_lines{20}=['%  DATE CREATION: ' date];
        %v_head_lines{21}='%  VERSION: 0';
        v_head_lines{21}='%';
        v_head_lines{22}='%  ';
        v_head_lines{23}='%  MODIFICATIONS (last commit)';
        v_head_lines{24}='%    $Date: 2013-04-18 14:51:29 +0200 (jeu., 18 avr. 2013) $';
        v_head_lines{25}='%    $Author: plecharpent $';
        v_head_lines{26}='%    $Revision: 851 $';
        v_head_lines{27}='%  ';
        v_head_lines{28}='% See also F_name1,...(fonctions dependantes/appelees, supprimer la ligne si aucune)';
        v_head_lines{29}='%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%';
end
%