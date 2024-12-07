function v_status=F_ps2pdf(v_in_file_path,varargin)
%F_PS2PDF  Creation d'un fichier pdf a partir d'un ps
%   F_ps2pdf(v_in_file_path [, v_out_dir])
%  
%   ENTREE(S): descriptif des arguments d'entree
%      - v_in_file_path : chemin du fichier a transformer
%      - v_out_dir : optionnel, chemin du repertoire de destination
%  
%   SORTIE(S): descriptif des arguments de sortie
%      - v_status : flag de retour de l'execution de la commande systeme
%  
%   CONTENU: 
%   Generation d'un fichier au format pdf a partir d'un fichier au
%   format postscript (ps) dans le meme repertoire ou dans un repertoire
%   different. 
%   Par defaut actuellement, le fichier ps est efface si la 
%   transformation est faite sans erreur.
%   
%   Systemes : Windows (via PDFCReator)  / Unix (via ps2pdf)
%  
%   APPEL(S): 
%      - F_ps2pdf('fichier.ps')
%      - F_ps2pdf('fichier.ps', 'd:\travail\fichiers_pdf')
%      - F_ps2pdf('d:\travail\fichiers_ps\fichier.ps') 
%      - F_ps2pdf('d:\travail\fichiers_ps\fichier.ps','d:\travail\fichiers_pdf') 
%  
%   EXEMPLE(S):
%      - 
%  
%  AUTEUR(S): P. Lecharpentier
%  DATE: 23-Jan-2009
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-06-19 14:28:06 +0200 (mer., 19 juin 2013) $
%    $Author: plecharpent $
%    $Revision: 940 $
%  
%  
% See also dos
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

vs_fparts=F_file_parts(v_in_file_path);
v_out_ext='.pdf';
% Flag effacement du fichier ps : pour l'instant non optionnel.
v_delete=true;
% Definition du repertoire de sortie
switch nargin
    case 1
        v_out_dir=vs_fparts.dir;
        
    case 2
        v_out_dir=varargin{1};
end
% Definition du chemin du fichier a creer
v_out_file_path=fullfile(v_out_dir,[vs_fparts.name v_out_ext]);
% Selon l'OS, appel de la commande de generation du fichier pdf
if ispc
    v_tool='PDFCreator';
    v_delete_str='';
    if v_delete
        v_delete_str=' /DeleteIF';
    end
    v_pdfcreator_path=fullfile(getenv('ProgramFiles'),'PDFCreator','pdfcreator.exe');
    if ~exist(v_pdfcreator_path,'file')
        v_pdfcreator_path=fullfile(getenv('ProgramFiles(x86)'),'PDFCreator','pdfcreator.exe');
    end
    v_status=dos(['"' v_pdfcreator_path '"' ' /IF"' v_in_file_path '" /OF"' v_out_file_path '"' v_delete_str]);
%
elseif isunix
    v_tool='ps2pdf';
    v_status=dos(['ps2pdf ' v_in_file_path ' ' v_out_file_path ]);
    if ~v_status
        if v_delete
            delete(v_in_file_path)
        end
    end
else
    % Mac (A VOIR)
end
% Warning si echec generation pdf
if v_status
    warning(['Le fichier pdf n''a pas ete cree, verifier l''existance de l''outil/la commande ' v_tool '!!!']);
end
