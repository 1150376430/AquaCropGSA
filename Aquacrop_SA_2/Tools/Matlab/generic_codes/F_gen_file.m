function F_gen_file(v_file_lines,v_file_path,v_save,v_edit)
%F_GEN_FILE  Creation et edition d'un fichier
%   F_gen_file(v_file_lines,v_file_path,v_save,v_edit)
%
%   ENTREE(S):
%      - v_file_lines : lignes du fichier (cell de string)
%      - v_file_path : chemin du fichier
%      - v_save : 1 (=ecriture du fichier), 0 (sinon)
%      - v_edit : 1 edition, 0 pas edition
%
%   SORTIE(S):
%      - pas d'argument de sortie
%
%   CONTENU:
%      - Creation d'un fichier, enregistrement et/ou edition dans l'editeur
%      Matlab
%
%   APPEL(S):
%      - com.mathworks.mlservices.MLEditorServices.openDocument
%      - com.mathworks.mlservices.MLEditorServices.newDocument
%      * depuis la version MATLAB Version 7.12 (R2011a) 09-Mar-2011
%  
%      - matlab.desktop.editor.openDocument
%      - matlab.desktop.editor.newDocument
%
%   EXEMPLE(S): cas d'utilisation de la fonction
%      - F_gen_file(lignes,'c:\dir\nom_fonction.m',1,0)
%      - F_gen_file(lignes,'c:\dir',0,1)
%
%  AUTEUR(S): P. Lecharpentier
%  DATE: 27-Nov-2006
%  VERSION: 0
%
%  MODIFICATIONS (last commit)
%    $Date: 2013-05-07 15:34:29 +0200 (mar., 07 mai 2013) $
%    $Author: plecharpent $
%    $Revision: 875 $
%  
%
% See also F_new_func, F_gen_xml_file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if nargin<3
    error('Pas assez d''argument...');
end
%
% Gestion compatibilite entre versions
% a partir de la version MATLAB Version 7.12 (R2011a) 09-Mar-2011
% changement acces aux services editeur
new_edt=datenum(version('-date'))>=datenum('09-Mar-2011');

if v_save
    % create the file in the current or specified (v_file_dir) directory if it doesn't exist
    if ~exist(v_file_path,'file')
        try
            newFile=fileDocument(v_file_path).open('w');
            newFile.print('%s\n',v_file_lines{:});
            newFile.close;
        catch
            F_disp(sprintf('Erreur lors de la creation du fichier %s',v_file_path))
        end
        if v_edit
            switch  new_edt
                case true
                    matlab.desktop.editor.openDocument(v_file_path);
                case false
                    com.mathworks.mlservices.MLEditorServices.openDocument(v_file_path);
            end
        end    
    else
        F_disp(sprintf('Attention le fichier %s existe deja  !!!\nOuverture de l''editeur...',v_file_path));
        F_disp(sprintf('\n<a href=".">Appuyer sur "Entree" pour continuer</a>'));
        pause;
        [v_status, v_result]=system([v_edit_progs.(varargin{1}).path ' ' v_file_path ' &']);
        if v_status
            open(v_file_path);
        end
    end
else
    % put the code into a new Editor buffer, file is not saved
    text=sprintf('%s\n',v_file_lines{:}) ;
    switch  new_edt
        case true
            matlab.desktop.editor.newDocument(text);
        case false
            com.mathworks.mlservices.MLEditorServices.newDocument(text);
    end
end

