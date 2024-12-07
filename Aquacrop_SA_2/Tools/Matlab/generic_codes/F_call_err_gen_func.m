function varargout=F_call_err_gen_func(v_calling_func_name,v_func_name,varargin)
% F_CALL_ERR_GEN_FUNC Appel d'une fonction en fonction de parametres
% stockes dans une structure definie en variable globale.
%   [...,...] = F_call_err_gen_func(v_calling_func_name,v_func_name[,...,...]) 
%
%   ENTREE(S): descriptif des arguments d'entree
%     * Arguments de la fonction:
%      - v_calling_func_name : nom de la fonction dans laquelle l'appel se
%      fait, on peut mettre systematiquement mfilename (qui renvoie le nom
%      de la fonction en cours d'execution lors de l'appel)
%      Si la fonction F_call_gen_err_func est appelee seule, mfilename==''
%      et n'aura aucun effet puisque le nom de la fonction appelante est
%      vide. Sinon il faut mettre explicitement le nom d'une fonction
%      appelable pour cela.
% 
%      - v_func_name : nom de la fonction a appeler
%      - optionnels : correspondent a tous les arguments de la fonction 
%      v_func_name appelee (obligatoires et optionnels)
%
%    * Autre que les arguments:
%     - vs_gen_err : structure declaree en tant que variable globale
%     determinant les conditions d'execution de la fonction v_func_name,
%     son nom est fixe.
%
%     La structure est renvoyee avec l'ensemble des champs et des valeurs
%     par defaut lorsque l'on appelle F_call_gen_err avec moins de 3
%     arguments, ex : global vs_gen_err; vs_gen_err=F_call_err_gen_func
%     Elle est construite a l'appel de la sous fonction F_get_funcs_struct
%     sur la base des informations referencees dans la sous-fonction
%     F_get_funcs_list sur les fonctions appelables (vc_func_list) 
%     et les fonctions appelantes (pour chaque fonction appelable, 
%     vc_calling_funcs), ainsi que l'autorisation ou non de l'appel pour chacune
%     d'elle (dans vc_calling_funcs_status).
%
%     Cette structure contient au premier niveau des champs ayant pour noms
%     ceux des fonctions referencees comme pouvant etres appelees par 
%     F_call_err_gen_func et un champ status qui autorise ou non l'appel 
%     (true, false: valeur par defaut)des fonctions.
%  
%     F_mat_data_rep: [1x1 struct]
%           F_rm_file: [1x1 struct]
%     F_file_data_rep: [1x1 struct]
%           F_str_rep: [1x1 struct]
%              status: 0
%     
%     Chaque champ au nom d'une fonction contient une structure d'informations sur
%     les arguments de la fonction appelable, son status d'execution,
%     la probabilite de son execution, ainsi que des informations 
%     sur les fonctions appelantes et le statut d'appelante:
%
%     varargs: {}    permet le passage d'arguments optionnels sans modifier
%     le code
%     nargs: 1       nombres d'arguments de sortie == arguments d'entree non
%                    modifies si l'appel de fonction n'est pas actif (un des champs
%                    status des differents niveaux de la structure == 0 (false).
%     status: 0     1 appel de la fonction, 0 sinon     
%     proba: champ optionnel      0 pas d'appel, >0 proba d'appel de la fonction
%     si status==1. Si status==1 et proba==0 : pas d'appel
%
%     calling_funcs: [1x1 struct] --> names: {'F_func_1'  'F_get_results'}
%                                     status: [0 0]
%
%
%     Par ex. : si le status global pour vs_gen_err==1
%     et le status d'execution de la fonction F_rm_file==1
%     et que le status correspondant a la fonction appelante
%     F_get_results==1, alors l'appel de F_rm_file realise avec
%     F_call_gen_err_func(mfilename,'F_rm_file','filename') dans
%     F_get_results sera effectif.
%
%     On a donc 3 niveaux d'intervention/de reglage pour l'execution d'une
%     fonction appelee avec F_call_gen_err_func.
%
%   SORTIE(S): descriptif des arguments de sortie
%      - Nombre d'arguments variable : ceux attendus pour la fonction appelee.
%      dans le cas ou cette fonction est executee entierement. Si
%      vs_gen_err.status est false ou le champ status de la structure 
%      de la fonction est a false, cette fonction renvoie par defaut
%      ses arguments d'entree pour fournir des valeurs dans le cas
%      ou normalement des variables d'entree doivent etre retournees
%      modifiees (dans le meme ordre que les arguments d'entree).
%
%   CONTENU:
%   La fonction permet l'execution d'une fonction sous-condition de
%   l'existence de la structure vs_gen_err declaree en variable gobale, et
%   du reglage des champs specifiques a la fonction a executer references
%   dans la sous-fonction F_get_funcs_list.
%
%   APPEL(S): liste des fonctions appelees
%      -sous-fonctions : F_get_funcs_struct, F_get_funcs_list
%
%   EXEMPLE(S): cas d'utilisation de la fonction
%      v_mat=F_call_err_gen_func(mfilename,'F_rand_nan_rep',v_mat)
%
%  AUTEUR(S): P. Lecharpentier
%  DATE: 22-Mar-2010
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-06-19 14:05:22 +0200 (mer., 19 juin 2013) $
%    $Author: plecharpent $
%    $Revision: 938 $
%  
%
% See also
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Declaration des variables globales
global v_display
global vs_gen_err



%% Traitement du nombre d'arguments de sortie de la fonction
if nargout
    varargout=cell(1,nargout);
else
    varargout={};
end

%% Si aucun argument n'est associe a la fonction appelee
% envoi d'un message si pas d'argument de sortie, renvoi
% de la structure contenant les infos sur les fonctions 
% appelables (cf. sous-fonction F_get_funcs_struct)
if nargin<3
    if ~nargout
        % En environnement interprete
        if ~isdeployed && (v_display || isempty(v_display))
            help F_call_err_gen_func
        else
            F_disp;
            F_disp('F_call_err_gen_func: Arguments insuffisants, consulter la documentation/l''aide sur la fonction');
            F_disp;
        end
    else
        % Appel F_get_funcs_struct pour retourner la structure associee aux
        % fonctions referencees appelables via F_call_err_gen_func
        vs_tmp=F_get_funcs_struct;
        varargout{1}=vs_tmp;
    end
    return
end


%% Test existance de la fonction/acces (path), et de la structure et de son
% contenu... si une au moins des conditions non remplie , on sort
if (~isstruct(vs_gen_err) || ~isfield(vs_gen_err,'status') || ~vs_gen_err.status)
    if nargin % on renvoie les varargin (il faut s'assurer que ce sont bien les arguments
        % d'entree qui sont supposes etre renvoyes dans le meme ordre) en
        % nombre egal (redimensionnement de varargout si besoin.
        if nargout<length(varargin)
            varargout=varargin(1:nargout);
        else
           varargout(1:length(varargin))=varargin; 
        end
    end
    return
else
    % Accessibilite de la fonction a executer
    if isempty(which(v_func_name))
        F_disp(['ATTENTION : la fonction ' v_func_name ' n''existe pas ou n''est pas accessible, verifier dans les path']);
    end
end

%% Initialisations
vc_funcs_list=F_get_funcs_list;

%%  Si le nom de la fonction n'est pas reference
if ~ismember(v_func_name,vc_funcs_list) || ~isfield(vs_gen_err,v_func_name)
    F_disp([' ATTENTION : la fonction ' v_func_name ' n''est pas referencee dans F_call_err_gen_func>F_get_funcs_list']);
    % ATTENTION : il faudrait renvoyer les arguments ... de la fonction
    if nargin % on renvoie les varargin (il faut s'assurer que ce sont bien les arguments
        % d'entree qui sont supposes etre renvoyes dans le meme ordre) en
        % nombre egal (redimensionnement de varargout si besoin.
        if nargout<length(varargin)
            varargout=varargin(1:nargout);
        else
           varargout(1:length(varargin))=varargin; 
        end
    end
    return
end

%% Initialisations, et tirage si proba globale specifiee dans vs_gen_err
% ou proba specifique a la fonction specifie dans le champ portant le nom
% de la fonction.
v_proba=1;
v_gen_err=1;
if isfield(vs_gen_err.(v_func_name),'proba') && vs_gen_err.(v_func_name).proba
    v_proba=vs_gen_err.(v_func_name).proba;
    % Calcul determinant l'execution de la fonction qui genere les erreurs
    v_gen_err=rand<v_proba;
end

%% Si le status n'est pas fixe ou la proba est nulle
if ~isfield(vs_gen_err.(v_func_name),'status') || ~vs_gen_err.(v_func_name).status || ~v_gen_err
    % TRAITEMENT IDENTIQUE A CELUI du niveau superieur (cf. avant)
    if nargin % on renvoie les varargin (il faut s'assurer que ce sont bien les arguments
        % d'entree qui sont supposes etre renvoyes dans le meme ordre) en
        % nombre egal (redimensionnement de varargout si besoin.
        if nargout<length(varargin)
            varargout=varargin(1:nargout);
        else
           varargout(1:length(varargin))=varargin; 
        end
    end
    return
end

%% Chargement de la structure contenant les infos sur les fonctions
% appelables
vs_funcs=F_get_funcs_struct;

%% Insertion du traitement du status de la fonction appelante
% Si la fonction appelante n'est pas dans les fonctions referencees comme
% pouvant appeler la fonction v_func_name ou si le status associe a cette
% fonction appelante est == false
% alors on sort.
v_isref_func=ismember(v_calling_func_name,vs_funcs.(v_func_name).calling_funcs.names);
v_func_index=find(ismember(vs_gen_err.(v_func_name).calling_funcs.names,v_calling_func_name));
if ~v_isref_func || isempty(v_func_index) || ~vs_gen_err.(v_func_name).calling_funcs.status(v_func_index)
    % TRAITEMENT IDENTIQUE A CELUI du niveau superieur (cf. avant)
    if nargin % on renvoie les varargin (il faut s'assurer que ce sont bien les arguments
        % d'entree qui sont supposes etre renvoyes dans le meme ordre) en
        % nombre egal (redimensionnement de varargout si besoin.
        if nargout<length(varargin)
            varargout=varargin(1:nargout);
        else
           varargout(1:length(varargin))=varargin; 
        end
    end
    return
end

%% Traitement des arguments supplementaires: en entree de la fonction,
% declares dans la structure. Ceux de la structure sont prioritaires.
if isfield(vs_gen_err,v_func_name) && isfield(vs_gen_err.(v_func_name),'varargs') && ...
        ~isempty(vs_gen_err.(v_func_name).varargs)
    n=vs_funcs.(v_func_name).nargs;
    v_args={varargin{1:n} vs_gen_err.(v_func_name).varargs{:}};
else
    v_args=varargin;
end

% Si au moins le nom de la fonction est donne
try
    [varargout{:}]=feval(v_func_name,v_args{:});
catch
    if isempty(v_args)
        F_disp(['Arguments manquants, voir l''aide de la fonction : ' v_func_name])
    else
        v_lasterror=lasterror;
        v_lasterror.message
        v_lasterror.stack
    end
    return
end



%% Sous-fonctions
    function vs_funcs=F_get_funcs_struct
        % Generation de la structure contenant les infos sur les fonctions
        % referencees (pour les tests developpement, non distribuees)
        [vc_funcs_list,vc_funcs_nargs,vc_calling_funcs,vc_calling_funcs_status]=F_get_funcs_list;
        for i=1:length(vc_funcs_list);
            vs_funcs.(vc_funcs_list{i}).varargs={};
            vs_funcs.(vc_funcs_list{i}).nargs=vc_funcs_nargs{i};
            vs_funcs.(vc_funcs_list{i}).status=false;
            vs_funcs.(vc_funcs_list{i}).proba=0;
            vs_funcs.(vc_funcs_list{i}).calling_funcs.names=vc_calling_funcs{i};
            vs_funcs.(vc_funcs_list{i}).calling_funcs.status=vc_calling_funcs_status{i};
        end
        % Status global activation ou non appel fonctions.
        vs_funcs.status=false;
    end

    function [vc_funcs_list,vc_funcs_nargs,vc_calling_funcs,vc_calling_funcs_status]=F_get_funcs_list
        % Declaration de la liste des fonctions appelables, des arguments a renvoyer, et 
        % pour chaque fonction appelable, la liste des fonctions qui
        % peuvent l'appeler et le status d'appel actif ou non actif (true/false).
        %
        % Voir la possibilite de les declarer dans un fichier csv ou mat
        vc_funcs_list={'F_mat_data_rep','F_rm_file','F_file_data_rep','F_str_rep'};
        vc_funcs_nargs={1,1,1,1};
        % La fonction F_func_1 est declaree systematiquement pour tests.
        vc_calling_funcs={{'F_func_1' 'F_get_results'},{'F_func_1' 'F_call_model'},{'F_func_1'}...
            ,{'F_func_1'}};
        vc_calling_funcs_status={[0 0],[0 0],[0],[0]};
    end
end


