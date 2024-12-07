function varargout = F_authors(v_login_name)
%F_AUTHORS  Affichage ou recuperation de la liste des auteurs
%   [vs_out_authors] = F_authors([v_login_name])
%  
%   ENTREE(S): 
%      - optionnel : v_login_name, nom du login de l'utilisateur
%  
%   SORTIE(S):
%      -  optionnel : vs_out_authors, structure contenant la liste du ou 
%         des auteurs specifiee dans cette fonction (authors). Les noms des
%         champs correspondent aux noms de login des utilisateurs.
%  
%   CONTENU: descriptif de la fonction
%  
%   APPEL(S): liste des fonctions appelees
%      - 
%  
%   EXEMPLE(S): cas d'utilisation de la fonction
%      - F_authors (affichage de tous les auteurs)
%      - F_authors('NomLogin') (affichage auteur NomLogin)
%      - vs_out_authors = F_authors      (recuperation de tous les auteurs)
%      - vs_out_authors = F_authors('NomLogin') 
%      (recuperation d'un auteur)
%  
%  AUTEUR(S): P. Lecharpentier
%  DATE: 09-Jan-2012
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-06-19 14:05:22 +0200 (mer., 19 juin 2013) $
%    $Author: plecharpent $
%    $Revision: 938 $
%  
%  
% See also F_msl_func_tpl
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Declaration des auteurs
vs_authors.plecharpent='P. Lecharpentier';
vs_authors.pclastre='P. Clastre';
vs_authors.sbuis='S. Buis';
% vs_authors.hvvarella='H. V. Varella';
% vs_authors.jbourges='J. Bourges';
vs_authors.anfournier='A. Fournier';
vs_authors.mweiss='M. Weiss';






if nargin
    if ismember(v_login_name,fieldnames(vs_authors))
        vs_out_authors.(v_login_name)=vs_authors.(v_login_name);
    else
        vs_out_authors.(v_login_name)= [v_login_name ' (user login)'];
        disp(['L''utilisateur ' v_login_name ' n''est pas dans la liste des auteurs']);
        disp('Utilisation du nom de login.');
    end
else
    vs_out_authors=vs_authors;
end
% Affichage de l'auteur demande ou de tous les auteurs
if ~nargout
    F_display;
    return
else
    varargout{1}=vs_out_authors;
end






    function F_display
        % Affichage Nom et login des auteurs declares
        v_nb=length(vs_out_authors);
        if v_nb==1
            disp('Auteur');
        else
            disp('Liste des auteurs');
        end
        for name=fieldnames(vs_out_authors)'
           disp([vs_out_authors.(name{1}) ' (' name{1} ')']); 
        end
    end


end
