function F_export_csv(v_file_path,vm_data,varargin)
% Export en csv une matrice de donnee avec possibilite labels en col/lignes
%   F_export_csv(v_file_path,vm_data,varargin)
%
%   ENTREE(S): descriptif des arguments d'entree
%      - v_file_path: string: chemin du fichier a creer. Si le fichier existe,
%      la fonction retourne une erreur
%      - vm_data: matrice de numerics (double) de dimension L lignes et C
%      colonnes
%      - varargin: possibilite d'ajouter les labels en ligne et en colonne,
%      dans ce cas le premier argument doit etre Legender les lignes et le
%      second les colonnes
%           - varargin{1}: cell de dimension L lignes et 1 colonne 
%           - varargin{2}: cell de dimension 1 ligne et C colonnes    
%           - varargin{3} :  nom de la premiere colonne (contenant le nom
%           des lignes)
%
%   ex: vm_data=        36  37.5 35.8
%                       2.1 2.2  2.3
%       varargin{1}=    {'Temperature';
%                       'hauteur(m)'}
%       varargin{2}=    {'jour 1','jour 2','jour 3'}
%
%   Le fichier en sortie:
%
%                 jour 1   jour 2   jour 3
%   Temperature    36       37.5     35.8
%   hauteur(m)     2.1      2.2      2.3
%
%
%
%   EXEMPLE(S): cas d'utilisation de la fonction
%      - F_export_csv('mon_fichier.csv',matrice)
%      - F_export_csv('c:\test\mon_fichier.csv',matrice,legende_lignes,legendes_colonnes)
%      -F_export_csv('c:\test\mon_fichier.csv',matrice,legende_lignes,legendes_colonnes,'NomCol1')
%
%  AUTEUR(S): J. Bourges
%  DATE: 20-Dec-2007
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-09-25 08:18:20 +0200 (mer., 25 sept. 2013) $
%    $Author: plecharpent $
%    $Revision: 976 $
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global v_overwrite;
F_set_overwrite;

% verification si ecrasement force du fichier
v_args=varargin;
nargs=nargin;
v_idx=cellfun(@islogical,varargin);
if any(v_idx)
    v_loc_overwrite=v_args{v_idx};
    v_args=v_args(~v_idx);
    nargs=nargs-1;
else
    v_loc_overwrite=v_overwrite;
end

% Label premiere colonne
v_first_col_label='';
if nargs==5 && ischar(v_args{1,3})
    v_first_col_label=v_args{1,3};
end
% Extraction des elements du chemin
vs_fparts=F_file_parts(v_file_path);
v_gen_file=true;
% Gestion du fichier : interactive si F_can_i_create_file accessible
% sinon on ecrase
if exist('F_can_i_create_file','file')
    v_gen_file=F_can_i_create_file(vs_fparts.dir,[vs_fparts.name vs_fparts.ext],v_loc_overwrite);
end
% Creation du fichier
if v_gen_file
    v_file=fileDocument(v_file_path).open('w');
    vm_sz=size(vm_data);
    if nargin>=4
        vc_row_label=v_args{1,1};
        vc_col_label=v_args{1,2};
        if ~all(vm_sz==[length(vc_row_label) length(vc_col_label)])
            v_file.close();
            error('F_export_csv : erreur de dimension (donnees, nom de lignes ou de colonnes) !');
        end
        v_file.print([v_first_col_label '%s\n'],sprintf(';%s',vc_col_label{:}));
        for i=1:vm_sz(1)
            v_file.print('%s%s\n',vc_row_label{i,1},sprintf(';%g',vm_data(i,:)));
        end
    else
        for i=1:vm_sz(1)
            v_file.print('%s\n',sprintf('%g;',vm_data(i,:)));
        end
    end
    v_file.close();
end
