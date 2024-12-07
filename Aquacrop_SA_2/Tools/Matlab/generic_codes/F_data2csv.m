function exitval=F_data2csv(v_csv_name,v_data,varargin)
% Genere un fichier csv a partir d'une structure de sequences
%   exitval = F_data2csv(v_csv_name,v_data[,v_delimiter,v_format,vc_headers])
%  
%   ENTREE(S): descriptif des arguments d'entree
%      - v_csv_name: string, nom du fichier a exporter (.csv)
%      - v_data: structure de cell, structure array ou numerical array
%     Optionnel:
%      - v_delimiter: separateur de colonnes
%      - v_format: chaine de formatage a inserer en 2eme ligne dans le
%      fichier
%      - vc_headers: liste des noms de colonnes (si v_data est 1 matrice)
%      - v_loc_overwrite:logical to overwrite file if true, or not if false
%      
%  
%   SORTIE(S): descriptif des arguments de sortie
%      - exitval: flag de validite
%  
%   CONTENU: descriptif de la fonction
%  
%   APPEL(S): liste des fonctions appelees
%      - F_cell2csv,F_user_input
%   
%  AUTEUR(S): J. Bourges
%  DATE: 31-Jan-2008
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-07-11 11:00:05 +0200 (jeu., 11 juil. 2013) $
%    $Author: plecharpent $
%    $Revision: 961 $
%  
%  
% See also F_cell2csv, F_user_input, struct2cell,csvDocument, F_csv2struct,
%   F_mat2csv,F_struct2csv
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Initialisations
global v_overwrite
F_set_overwrite;

v_loc_overwrite=false;

if nargin<2
   error('Nombre d''arguments insuffisant') 
else
    for i=1:length(varargin)
        if iscell(varargin{i})
            vc_headers=varargin{i};
        elseif ischar(varargin{i})
            if ~isletter(unique(varargin{i}))
                v_delimiter=varargin{i};
            elseif ~isempty(strfind(varargin{i},'%'))
                v_format=varargin{i};
            end
        elseif islogical(varargin{i}) || isnumeric(varargin{i})
            v_loc_overwrite=logical(varargin{i});
        end
    end
end
if ~exist('v_delimiter','var')
    v_delimiter=';';
end
if ~ischar(v_csv_name)
   error('The file name is not valid !') 
end

if isnumeric(v_data)
    vc_data=mat2cell(v_data,size(v_data,1),ones(1,size(v_data,2)));
    if ~exist('vc_headers','var')
       error('Column headers must be provided !') 
    end
    vc_labels=vc_headers;
elseif isstruct(v_data)
    try
        vc_data=struct2cell(v_data)';
    catch % convert structure array to structure
        vc_data=struct2cell(csvDocument.convertArrayToStruct(v_data))';
    end
    vc_labels=fieldnames(v_data);
else
    error('This data type is not supported : %s !',class(v_data))
end

v_nb_col=max(size(vc_data));
v_nb_lines=max(size(vc_data{1,1}));

%% struct -> cell

for j=1:v_nb_col
    if isnumeric(vc_data{1,j})
        tmp=vc_data{1,j};
        for i=1:v_nb_lines
            vc_data{i,j}=tmp(i);
        end
    end
    if iscell(vc_data{1,j})
        tmp=vc_data{1,j};
        for i=1:v_nb_lines
            if isempty(tmp{i})
                vc_data{i,j}={};
            else
                if ~iscell(tmp{i})
                    vc_data{i,j}=tmp{i};
                else
                    vc_data{i,j}=sprintf('%s%s',tmp{i}{1,1},sprintf(',%s',tmp{i}{2:length(tmp{i})}));
                end
            end
        end
    end
end

%% cell -> csv

vc_export=cell(v_nb_lines+2,v_nb_col);

datal=2;
if exist('v_format','var') && ~isempty(v_format)
    if isempty(strfind(v_format,v_delimiter))
        v_format=strrep(v_format,'%',[v_delimiter '%']);
        v_format=v_format(2:end);
    end
    vc_format=csvDocument().stringToCell(v_format,v_delimiter);
    vc_export(2,:)=vc_format;
    datal=3;
else
    vc_export=vc_export(1:end-1,:);
end
vc_export(1,:)=vc_labels;
vc_export(datal:v_nb_lines+datal-1,:)=vc_data;

if exist(v_csv_name,'file')
    F_set_overwrite;
    if ~any([v_overwrite v_loc_overwrite])
        v_del=F_user_input(['Le fichier ',v_csv_name,' existe deja. Ecraser ?'],{'oui','non'},[true false]);
    else
       v_del=true; 
    end
    if v_del
        delete(v_csv_name)
        F_disp(sprintf('Fichier %s Ecrase \n',v_csv_name));        
    else
        exitval=0;
        return;
    end    
end
try
    try
        F_cell2csv(v_csv_name,vc_export,v_delimiter);
    catch
       error('Erreur lors de l''ecriture du fichier %s',v_csv_name) 
    end
catch
    F_create_message(v_csv_name,'Le fichier ne peut etre cree (droits, deja ouvert,...)',1,1,lasterror)
end
exitval=1;


