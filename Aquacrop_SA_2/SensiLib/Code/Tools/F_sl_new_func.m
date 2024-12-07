function F_sl_new_func(varargin)
%F_SL_NEW_FUNC Cree un nouveau fichier M-File dans l'editeur Matlab
%   F_sl_new_func([v_function_name,v_save,v_file_dir])
%  
%   ENTREE(S): 
%       - v_function_name : nom de la nouvelle fonction a creer
%       - utiliser v_save ou v_file_dir (si v_file_dir est donne le fichier est 
%         enregistre
%            * v_save : 1 pour enregistrer,  0 (valeur par defaut) sinon
%            * v_file_dir : chemin du repertoire dans lequel le fichier
%            sera cree
%
%   SORTIE(S): 
%       - pas d'argument de sortie
%       - un fichier temporaire ou enregistre sous le nom F_nom_fonction.m
%       ,si pas d'argument, ou F_[v_function_name].m, sinon dans le
%       repertoire courant ou designe par v_file_dir.
%       
%
%   CONTENT: 
%       Creation d'un fichier M pre-formate (definition fonction, section d'aide )
%       avec un nom par defaut (F_nom_fonction) ou v_function_name si specifie. 
%       Le fichier peut etre sauve dans le repertoire courant (v_save=1) ou automatiquement
%       dans un repertoire specifique (v_file_dir).
%       Le fichier est ouvert par defaut dans une fenetre d'edition.
%
%   CALLS: 
%       - F_sl_func_tpl
%       - F_sl_gen_file
%  
%   EXAMPLE(S): 
%       F_sl_new_func()
%       F_sl_new_func(my_func)
%       F_sl_new_func(my_func,1)
%       F_sl_new_func(my_func,'c:\homedir\matlabdir')
%  
%  AUTHOR(S): P. Lecharpentier + modifs S. Buis
%  DATE: 23-Nov-2006
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-06-19 14:49:50 +0200 (mer., 19 juin 2013) $
%    $Author: plecharpent $
%    $Revision: 40 $
%  
%  
% See also F_msl_func_tpl, F_gen_file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% par defaut pas d'enregistrement du fichier et dir=rep courant (workspace)
v_gen=0;
v_save=0;
v_file_dir=pwd;
%
switch nargin
    case 0
        disp('Specifier le nom de la fonction e creer...')
    case {1,2}
        v_gen=1;
        v_function_name=lower(varargin{1});
        v_function_name=regexprep(v_function_name, ' *', '_');
        % if the arg is a char : file directory
        if nargin==2
            if ischar(varargin{2})
                v_save=1;
                v_file_dir=varargin{2};
            elseif isnumeric(varargin{2})
                v_save=varargin{2};
            end
        end
    otherwise
        error('Trop d''arguments specifies...');
end
if v_gen
    % recuperation des lignes a creer dans le nouveau M-file et du nom du fichier
    % via F_msl_func_tpl 
    [v_head_lines,v_file_name]=F_sl_func_tpl(v_function_name);
    %
    v_file_path=fullfile(v_file_dir,v_file_name);
    % appel du generateur de fichier (+enregistrement et ou edition)
    try
        F_sl_gen_file(v_head_lines,v_file_path,v_save,1);
    catch
        error('Le fichier %s n''a pas pu etre cree',v_file_path);
    end
end
