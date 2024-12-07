function vs_error = F_gen_error_struct(varargin)
%F_GEN_ERROR_STRUCT  Creation d'une structure d'erreur Matlab
%   vs_error = F_gen_error_struct([vso_error,v_identifier,v_message])
%  
%   ENTREE(S): descriptif des arguments d'entree
%      - vso_error: structure error ou objet MException
%      ou
%      - v_identifier : identifiant d'un type d'erreur (ex: MSLIB:fileError)
%      - v_message : messsage d'explication, precision de la source de l'erreur
%  
%   SORTIE(S): descriptif des arguments de sortie
%      - vs_error: structure d'erreur avec 3 champs
%          message : message de l'erreur
%          identifier : identifiant de l'erreur
%          dbstack : trace de l'erreur
%              tableau de structures avec les champs: file, name,line
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
%  DATE: 20-Nov-2008
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-06-19 14:15:52 +0200 (mer., 19 juin 2013) $
%    $Author: plecharpent $
%    $Revision: 939 $
%  
%  
% See also dbstack, MException,error
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Generation de la structure d'erreur vide (retournee si aucun argument
% fourni)
vs_error.message='';
vs_error.identifier='';
vs_error.dbstack=dbstack('-completenames');

% remplissage (sauf stack pour l'instant) ou non de la structure
switch nargin
    case 0
        return;
    case 1
        % si structure erreur ou objet MException
        % remplissage d'une structure d'erreur
        if isstruct(varargin{1}) || isa(varargin{1},'MException')
            for i={'message', 'identifier','stack','dbstack'}
                try
                    vs_error.(i{1})=varargin{1}.(i{1});
                catch
                end
            end
            if isfield(vs_error,'stack')
               vs_error.dbstack=vs_error.stack;
               vs_error=rmfield(vs_error,'stack');
            end
            return;
        end
        % on donne le message
        if ischar(varargin{1}) && isempty(strfind(varargin{1},':'))
            vs_error.message=varargin{1};
        else
            error('Il faut fournir le message associe e l''identifiant de l''erreur !');
        end
    otherwise
        % on donne un message pour l'erreur
        if ischar(varargin{1}) && isempty(strfind(varargin{1},':'))
            vs_error.message=varargin{1};
        % on donne un identifiant et un message pour l'erreur
        else
            vs_error.identifier=varargin{1};
            if ~ischar(varargin{2})
                error('Le deuxieme argument doit etre un message...');
            else
                % on renseigne le message
                if nargin > 2 && ~isempty(strfind(varargin{2},'%'))
                    vc_args=varargin(2:end);
                    vs_error.message=sprintf(vc_args{:});
                else
                    vs_error.message=varargin{2};
                end
            end
        end
end
