function F_test_mfile_rev(m_filename,rev_info,exec_key)
%F_TEST_MFILE_REV  Test egalite des revisions de fichiers du repertoire
% temporaire multisimlib et de leur equivalent dans les repertoires
% correspondants des fonctions
%   F_test_mfile_rev(m_filename,rev_info,startup_key)
%
%   ENTREE(S): descriptif des arguments d'entree
%      - m_filename : nom du fichier .m
%      - rev_info : Chaine de caractere comportant l'info sur la revision
%      du fichier (ex: '$Revision: 1015 $')
%      - optionnel: exec_key : utilisation pour lors de l'execution de
%      la fonction startup pour l'installation de la distribution, ou si
%      le controle a deja ete fait, true si execution a faire , false sinon
%
%   SORTIE(S): descriptif des arguments de sortie
%
%
%   CONTENU: descriptif de la fonction
%
%   APPEL(S): liste des fonctions appelees
%      -
%
%   EXEMPLE(S): cas d'utilisation de la fonction
%      -
%
%  AUTEUR(S): P. Lecharpentier
%  DATE: 08-Aug-2012
%  VERSION: 0
%
%  MODIFICATIONS (last commit)
%    $Date: 2013-11-26 10:57:07 +0100 (mar., 26 nov. 2013) $
%    $Author: plecharpent $
%    $Revision: 1015 $
%
% See also F_disp, F_load_envpaths
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Pas de verification par defaut
v_exec=false;

if (nargin==1 && islogical(m_filename))
    v_exec=m_filename;
end
if (nargin>2 && islogical(exec_key))
    v_exec=exec_key;
end

% Pas de verification
if ~v_exec
    return
end

% Si appel pour auto-verification
if nargin<2
    rev_info='$Revision: 1015 $';
    m_filename='F_test_mfile_rev';
end

m_filename=[m_filename '.m'];


[v_root,v_dirs,v_paths]=F_load_envpaths('all',false);

v_file_path='';
switch m_filename
    case {'F_MSLIB_Mode_1_standard.m' 'F_MSLIB_Mode_4_incertitude.m' 'F_MSLIB_Mode_5_sensi.m'}
        v_file_path=fullfile(v_root,v_dirs.main,m_filename);
    case {'F_main_valid.m' 'F_main_opti.m' 'F_valid_sim_obs.m'}
        v_file_path=fullfile(v_root,v_paths.opti{1},m_filename);
    case {'F_set_path.m' 'F_rm_path.m' 'F_test_mfile_rev.m' 'F_disp.m' 'F_get_tmp_path.m' ...
            'F_load_envpaths.m' 'F_log.m' 'F_set_env.m' 'F_set_display.m' 'F_set_pause.m' ...
            'F_set_overwrite.m' 'F_user_input.m','F_version.m'}
        v_file_path=fullfile(v_root,v_paths.common{1},m_filename);
end
% function called donesn't exist in user temp dir
try
    content=fileread(v_file_path);
catch
    F_create_message('Missing file in installation', 'please execute F_startup function to fix it',1,1)
end

idx=strfind(content,'$Revision:');
idxend=strfind(content,'$');
if length(idx)>1
    if strcmp(m_filename,[mfilename '.m'])
        idx=idx(2);
    else
        idx=idx(end);
    end
end
idxend=idxend(idxend>idx);

try
    rev_info_ori = content(idx:idxend(1));
    mrev_ori = str2double(rev_info_ori(regexp(rev_info_ori,'[0-9]')));
catch
    disp('erreur')
end

mrev = str2double(rev_info(regexp(rev_info,'[0-9]')));

if mrev_ori > mrev
    % Affichage et forcage arret prog. par ctrl+c
    v_mess=sprintf('\n\n%s\n%s\n%s','ATTENTION',['La version de ' m_filename ' n''est pas correcte'],...
        'Executer de nouveau F_startup!');
    F_disp(v_mess,'stop',false);
end

