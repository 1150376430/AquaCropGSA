function F_cell2csv(filename,cellArray,delimiter)
%  Exportation d'un cell en fichier csv
%   F_cell2csv(filename,cellArray,delimiter)
%  
%   ENTREE(S): descriptif des arguments d'entree
%      - filename: string, nom du fichier a sauvegarder
%      - cellArray: cell aray of strings, cell a exporter
%      - delimiter: delimiteur d'ecriture, le plus souvent ';'
%        si non fourni ',' est pris par defaut.
%  
%  
%  AUTEUR(S): Sylvain Fiedler, KA, 2004
%             Nom du code original : cell2csv.m
%             Licence : cell2csv_license.txt
%
%  DATE: 12-Feb-2008
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-06-26 13:38:25 +0200 (mer., 26 juin 2013) $
%    $Author: plecharpent $
%    $Revision: 953 $
%  
%
%  Modifications apportees au code original: utilisation fileDocument
%  suppression eval, num2str 
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin<3
    delimiter = ',';
end


fileobj=fileDocument(filename).open('w');

for z=1:size(cellArray,1)
    for s=1:size(cellArray,2)
        var = cellArray{z,s};
        if size(var,1) == 0
            var = '';
        end
        if isinteger(var) || islogical(var)
            v_format='%d';
        elseif isnumeric(var)
            v_format='%g';
        elseif ischar(var);
            v_format='%s';
        else
            error('Data format unsupported!');
        end
        
        fileobj.print(v_format,var);
        if s ~= size(cellArray,2)
            fileobj.print(delimiter);
        end
    end
    fileobj.print('\n');
end
fileobj.close();
