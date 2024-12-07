function [vs_struct,csv] = F_csv2struct(v_csv_file,varargin)
%F_CSV2STRUCT
%   vs_struct = F_csv2struct(v_csv_file[,v_type,v_header_size,...
%              v_format,v_header,v_delim])
%
%   ENTREE(S): descriptif des arguments d'entree
%      - v_csv_file: name or path of file
%      - optional
%           - v_type: kind of desired structure (array pr struct)
%           - v_header_size :  number of lines (if exist in file)
%           - v_format : formatting string for reading file lines (i.e
%              '%s%s%d%f' for example)
%           - v_header : string with column names (with delimiter)
%           - v_delim : delimiter (default value : ';')
%
%   SORTIE(S): descriptif des arguments de sortie
%      - vs_struct : structure of data according to v_type
%      - csv : csvDocument object (containing the data structure)
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
%  DATE: 30-Nov-2012
%  VERSION: 0
%
%  MODIFICATIONS (last commit)
%    $Date: 2013-11-13 18:09:21 +0100 (mer., 13 nov. 2013) $
%    $Author: plecharpent $
%    $Revision: 1008 $
%
% See also csvDocument,
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~nargin
    error('Nom de fichier non fourni !')
end
vc_struct_type={'struct','array'};
v_type='';
v_header_size=0;
v_format='';
v_header='';
v_delim=';';
if ~isempty(varargin)
    for i=1:length(varargin)
        if ischar(varargin{i})
            if ismember(varargin{i},vc_struct_type);
                v_type=varargin{i};
                % c'est un format ou une ligne d'en-tete, delimiter
            elseif ~isempty(strfind(varargin{i},'%'))
                v_format=varargin{i};
            elseif size(varargin{i},2)==1 % delimiter
                v_delim=varargin{i};
            else
                v_header=varargin{i};
                v_header_size=0;
            end
        elseif isnumeric(varargin{i})
            v_header_size=varargin{i};
        else
            % ??
        end
    end
end

% csv file instance
csv=csvDocument(v_csv_file);
% setting struct type to produce
csv=csv.setStructType(v_type);

% setting reading delimiter
csv=csv.setDelimiter(v_delim);

% Number of headerlines in the file

if v_header_size==2
    % Suppose que header en 1 ligne et format en 2eme
    csv=csv.setDataHeader(1);
    csv=csv.setDataFormat(2);
    % Et si inverse ?
elseif v_header_size==1
    v_is_header=true;
    v_is_format=true;
    try
        csv=csv.setDataHeader(1);
    catch headerError
        v_is_header=false;
    end
    if ~v_is_header
        try
            csv=csv.setDataFormat(1);
        catch formatError
            v_is_format=false;
        end
    end
end

% Reading format string
if ~csv.isSetDataFormat
    csv=csv.setDataFormat(v_format);
end
% Columns header string
if ~csv.isSetDataHeader
    csv=csv.setDataHeader(v_header);
end
% structure loading
csv=csv.loadContent;
vs_struct=csv.Content;
