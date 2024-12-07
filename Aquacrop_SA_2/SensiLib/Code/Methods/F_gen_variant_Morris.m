 function vm_in_mat = F_gen_variant_Morris(vs_factors_def,vs_method_options)
% Generation des variants pour la methode de Morris.
%
% Generazione delle "varianti" per il metodo di Morris
% Cette fonction sert a generer un echantillon pour le calcul des indices 
% principaux et totaux avec la methode de Morris. Cette methode est
% decrite en detail dans le document "La Methode de Morris et ses extensions"
% qui servira de reference dans les commentaires suivants (notamment pour 
% les formules utilisees).
%
%
% ENTREES :
% 
%
%      - vs_factors_def : struttura di definizione dei fattori                                                                                       
%                         (structure de definition des facteurs)
%          o vs_factors_def.Dist (OPTIONNEL) : vecteur de cell contenant le type de distribution pour
%            chaque facteur.
%            Pour voir la liste des distributions disponibles, executer la
%            fonction F_create_sample() sans argument.
%            ATTENTION: pour utiliser des lois autres que les lois uniforme et 
%            triangulaire il est necessaire d'avoir la toolbox matlab "statistics".
%            ATTENTION: la methode ne fonctionne pas avec la distribution
%            'discrete'.
%            Si ce champ n'est pas precise ou est vide, les distributions des facteurs seront toutes fixees e
%            'uniform'. 
%            Si le vecteur ne contient qu'une seule distribution alors tous les facteurs auront
%            la distribution donnee.
%            Dans ces deux derniers cas le champ Nb devra etre
%            precise (cf. ci-apres).
%          o vs_factors_def.DistParams (OPTIONNEL) : vecteur de cell
%            contenant le vecteur des parametres de la distribution 
%            pour chaque facteur. 
%            Pour voir la liste des parametres requis pour chaque distribution
%            disponible, executer la fonction F_create_sample() sans argument.
%            Si ce champ n'est pas fourni ou est vide, les parametres
%            seront fixes a 0 et 1.
%            Si ce champ ne contient qu'un vecteur de parametre, ces
%            parametres seront utilises pour toutes les distributions.
%          o vs_factors_def.Nb (OPTIONNEL) : scalaire contenant le
%            nombre de facteurs. Obligatoire si le champ Dist n'est pas
%            precise, est vide ou ne contient qu'une seule distribution. 
%
%      - vs_method_options : structure de definition des options de la
%        methode
%          o vs_method_options.p : nombre de niveaux de la grille r�guli�re.
%            Type : scalaire si tous les facteurs ont le m�me nombre de
%            niveaux, vecteur de taille le n� de facteurs si le nombre de 
%            niveaux est diff�rent selon les facteurs.
%          o vs_method_options.n : (OPTIONNEL) rapport delta/taille d'un pas.
%            (taille valant 1/(p-1)) ATTENTION :
%            NE PEUT PAS ETRE SUPERIEUR OU EGAL A  p. 
%            Valeur par d�faut : 2.
%            Type : scalaire si une seule valeur pour tous les facteurs,
%            vecteur de taille le n� de facteurs si valeurs diff�rentes
%            selon les facteurs.
%          o vs_method_options.r : nombre de trajectoires (type : scalaire)
%          o vs_method_options.Q : (OPTIONNEL) nombre de groupe de r trajectoires sur lesquels s'effectue la
%            s�lection des r trajectoires (type : scalaire). Valeur par
%            d�faut : 100.
%          o vs_method_options.incert : (OPTIONNEL) methode d'estimation des
%          incertitudes sur les indices calcul�s : 'bootstrap' (par
%          bootstrap, i.e. par r�-�chantillonnage de m groupes de trajectoires 
%          parmi les r  -> r*(k+1) simulations du mod�le), ou 'r�plication'
%          (par r�plication, i.e. qu'on r�p�te m fois le plan d'exp�rience
%          de r trajectoires -> r*(k+1)*m simulations du mod�le).
%          Valeur par d�faut : bootstrap.
%          o vs_method_options.m : (OPTIONNEL) nombre de
%            r�-�chantillonnage boostrap ou nombre de r�plicats de groupes de r 
%            trajectoires contenus dans la matrice en sortie ou  (selon valeur de vs_method_options.incert).
%            Valeur par d�faut : r si bootstrap, 5 si r�plication.
%
%%  INPUT:
%         - vs_factors_def : struttura di definizione dei fattori  
%                  o  vs_factors_def.Dist (Opzionale) :  vettore cella contenente il tipo di distribuzione   
%                       per ogni fattore. Per vedere la lista delle distribuzioni disponibili eseguire la  
%                       funzione F_create_sample() senza argomento 
%                       ATTENZIONE: per utilizzare delle leggi oltre che le leggi uniforme 
%                       e triangolare � necessario avere il toolbox matlab �statistics�.   
%                       il metodo non funziona con la distribuzione discreta
%                       se questo campo non � specificato le distribuzioni saranno tutte uniformi
%                       se il vettore contiene una sola distribuzione, allora tutti i fattori avranno la stessa 
%                       distribuzione.
%                       IN QUESTI 2 CASI IL CAMPO Nb DOVRA� ESSERE SPECIFICATO
%                   o  vs_factors_def.DistParams (Opzionale): vettore cella contenente il vettore dei 
%                        parametri della distribuzione per ciascun fattore.
%                        Per vedere la lista dei parametri richiesti per ciascuna distribuzione disponibile, 
%                        eseguire la funzione F_create_sample() senza argomento 
%                        IN QUESTI 2 ULTIMI CASI IL CAMPO Nb DOVR� ESSERE SPECIFICATO
%                   o   vs_factors_def.Nb (Opzionale) : scalare contenente il numero dei fattori (k in Campolongo et al.)
%                       Obbligatorio se il campo Dist non � precisato, � vuoto o contiene una sola distribuzione.
%         - vs_method_options : struttura di definizione delle opzioni del metodo
%                   o   vs_method_options.p : numero di colonne (livelli) della griglia regolare.
%                       Tipo: scalare se tutti i fattori hanno lo stesso numero di colonne   
%                       (livelli), vettore di dimensione pari al numero di fattori se il 
%                       numero di livelli � differente per ciascun fattore
%                   o   vs_method_options.n : (OPTIONNEL) rapporto Delta/dimensione di un 
%                       pas. (?) () (taille valant 1/(p-1))
%                       ATTENZIONE: non pu� essere superiore o uguale a p
%                       Valore di default : 2. (anche se nell�esempio Demo
%                       � 1�) DEVE ESSERE UN NUMERO INTERO
%                       Tipo: scalare se tutti i fattori hanno lo stesso numero di colonne
%                       (livelli), vettore di dimensione pari al numero di fattori se il 
%                       numero di livelli � differente per ciascun fattore
%                   o   vs_method_options.r : numero di traiettorie (tipo: scalare)
%                   o   vs_method_options.Q : (Opzionale) numero del gruppo di r      
%                       traiettorie sulle quali si effettua la selezione delle r             
%                       traiettorie (tipo: scalare). Valore di default : 100 . (Demo = 50, 
%                       M in Campolongo et al., con valori tra 500 e 1000�)
%                   o vs_method_options.incert : (OPTIONNEL) metodo di stima delle incertezze sugli indici calcolati: �bootstrap� �
%                   o vs_method_options.m : (OPTIONNEL)    �   
% 

%   SORTIE(S): descriptif des arguments de sortie
%      - v_in_mat : le groupe de r trajectoires de distance interne
%      maximale (type : matrice de taille (r*(k+1),k)
%  
%   CONTENU: descriptif de la fonction
%      - s�lection d'un groupe de r trajectoires de distance interne maximale parmi 
%        Q groupes de r trajectoires
%     
%  AUTEUR(S): Cyril AUCLAIR (stagiaire de Samuel BUIS � l'INRA PACA mai-septembre 2013)
%  DATE CREATION: 13-Jun-2013
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-06-19 14:49:50 +0200 (mer., 19 juin 2013) $
%    $Author: plecharpent $
%    $Revision: 40 $
%  
%   OUTPUT (S): descrizione degli argomenti di output
%     - v_in_mat : gruppo di r triettorie di distanza interna massimale
%       Tipo: matrice di dimensioni (r*(Nb+1),Nb)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Definition du tableau contenant les options de la methode
% Definizione della tabella contenente le opzioni del metodo. Crea 6
% sottotrutture (contenute in un unica struttura chiamata vc_options_desc),
% una per ogni input (specificato o meno) richiesto (p, n, r, Q, incert,
% m). Valgono le regole per la specificazione degli input sopra elencate. 
vc_options_desc=struct('name',{'p','n','r','Q','incert','m'},...
    'datatype',{'uint32','uint32','uint32','uint32','char','uint32'},...
    'status',{'non optional','optional','non optional','optional','optional','optional'},...
    'defaultvalue',{[],2,[],100,'bootstrap',[]},...
    'comments',{'Nombre de modalit� des facteurs',...
                'Rapport delta/taille d un pas',...
                'Nombre de trajectoires',...
                'Nombre de groupe de r trajectoires sur lesquels s''effectue la s�lection des r trajectoires',...
                'methode d''estimation des incertitudes sur les indices calcul�s : ''bootstrap'' ou ''r�plication''',...
                'Nombre de r�-�chantillonnages boostrap ou nombre de r�plicats de groupes r trajectoires'});

%% Retour de la structure pour verification si appel sans arguments
if nargin==0
    vm_in_mat=vc_options_desc;
    return
end

%% Renseignement des options par defaut
for i=1:length(vc_options_desc)
    if ~isfield(vs_method_options,vc_options_desc(i).name)
        if strmatch('optional',vc_options_desc(i).status,'exact')
            vs_method_options.(vc_options_desc(i).name)=vc_options_desc(i).defaultvalue;
        else
            error(['L''option ' vc_options_desc(i).name ' doit etre renseignee.'])
        end
    end
end
F_create_message('Probleme dans les arguments en entree',...
    'L''option incert doit contenir ''bootstrap'' ou ''replication''',...
    ~strcmpi(vs_method_options.incert,{'bootstrap','replication'}),1);
if ~isfield(vs_method_options,'m') || isempty(vs_method_options.m)
    if strcmpi(vs_method_options.incert,'bootstrap')
        vs_method_options.m=vs_method_options.r;
    elseif strcmpi(vs_method_options.incert,'replication')
        vs_method_options.m=5;
    end
end

%% Tests divers sur les arguments
if ~isfield(vs_factors_def,'Dist') || isempty(vs_factors_def.Dist)
    vs_factors_def.Dist={'uniform'};
end
if length(vs_factors_def.Dist)==1
    F_create_message('Probleme dans les arguments en entree',...
            'Lorsque le champ dist de l''argument vs_factors_def n''est pas fourni ou ne contient qu''une distribution, le champ Nb de l''argument vs_factors_def doit etre defini.',...
            ~isfield(vs_factors_def,'Nb') || isempty(vs_factors_def.Nb),1);
    vs_factors_def.Dist=mat2cell(repmat(vs_factors_def.Dist{1},vs_factors_def.Nb,1),ones(1,vs_factors_def.Nb),length(vs_factors_def.Dist{1}));
else
    vs_factors_def.Nb=length(vs_factors_def.Dist);
end
F_create_message('',...
    'La methode ne fonctionne pas avec la distribution ''discrete''.',...
    ~isempty(strmatch('discrete',vs_factors_def.Dist,'exact')),1);
if ~isfield(vs_factors_def,'DistParams') || isempty(vs_factors_def.DistParams)
    vs_factors_def.DistParams={[0,1]};
end
if length(vs_factors_def.DistParams)==1
    for i=2:vs_factors_def.Nb
        vs_factors_def.DistParams{i}=vs_factors_def.DistParams{1};
    end
end      
for i=1:vs_factors_def.Nb
    [v_checked, v_flag_bounded] = F_check_distr(vs_factors_def.Dist{i},vs_factors_def.DistParams{i});
    F_create_message(['Probl�me avec la distribution du facteur ' num2str(i)],...
        'La methode ne fonctionne pas avec les distributions non born�es.',...
        ~v_flag_bounded,1);
    F_create_message(['Probl�me avec la distribution du facteur ' num2str(i)],...
        'Voir messages ci-dessus.',...
        ~v_checked,1);
end

%% Code de la m�thode

k = vs_factors_def.Nb; 
p = vs_method_options.p;
if (length(p) == 1 && k~=1)
    p = p*ones(1,k);          % il numero di livelli pu� variare per ogni fattore d'input. pertanto p dovr� essere un vettore dove ogni elemento i-esimo � il livello dell'i-esimo parametro. 
end                           % se i livelli sono uguali per ogni parametro questa funzione trasforma p in un vettore di k elementi (ripetendo sempre lo stesso valore)
n = vs_method_options.n;
if (length(n) == 1 && k~=1)
    n = n*ones(1,k);          %stesso discorso di p
end
r = vs_method_options.r;
Q = vs_method_options.Q;
if strcmp(lower(vs_method_options.incert),'replication')
    m = vs_method_options.m;
else
    m=1;
end
if n>=p
     error('ERREUR : La fonction F_gen_variant_Morris(k,p,n,r,Q) ne doit pas �tre appel�e avec le facteur n sup�rieur ou �gal � p.')
else
    if (n-floor(n))~=0
        error('ERREUR : La fonction F_gen_variant_Morris(k,p,n,r,Q) ne doit pas �tre appel�e avec un facteur n non entier.');
    end                        % n deve essere un numero intero!
    vm_in_mat = zeros((k+1)*r*m,k);
    for j = 1 : m
        [vc_h2,v_D1] = F_SelecTrajEtCalculDist(k,p,n,r); 
        v_Dmin = v_D1;
        vc_hmin = vc_h2;
        for i = 1:Q-1
        [vc_SelectionTrajectoires,v_D2]=F_SelecTrajEtCalculDist(k,p,n,r);
            if v_D2>v_D1
                vc_h2= vc_SelectionTrajectoires;
                v_D1= v_D2;
            end
% partie � d�commenter pour avoir un calcul de l'ensemble de trajectoires ayant
% une distance totale minimale
%
%            if v_D2<v_Dmin
%                vc_hmin = vc_SelectionTrajectoires;
%                v_Dmin = v_D2;
%            end
        end
        
% partie � d�commenter pour avoir un affichage de plots montrant les
% trajectoires de vc_h2 et vc_hmin dans un plan (sur les 2 premiers facteurs)
%
%        figure
%hold on
%for i = 1 :vs_method_options.r
%plot(vc_h2{i}(:,1),vc_h2{i}(:,2));
%end
%hold off
%figure
%hold on 
%for i = 1 :vs_method_options.r
%plot(vc_hmin{i}(:,1),vc_hmin{i}(:,2));
%end
        
        for i = 1:r
            vm_in_mat((j-1)*r*(k+1)+(i-1)*(k+1)+1 : i*(k+1)+(j-1)*r*(k+1), :)=vc_h2{i};
        end
    end
end
    
for i=1:k
    [v_tmp, vm_in_mat(:,i)]=F_inverse_cdf(vs_factors_def.Dist{i},vs_factors_def.DistParams{i},vm_in_mat(:,i));
end


function [vc_selecTraj,v_distance] = F_SelecTrajEtCalculDist(k,p,n,r)
% s�lection des r trajectoires dans une matrice de matrices et insertion dans
% une matrice ~ de la distance globale D de cette ensemble de trajectoires
% arguments en entr�e :
% * k : dimension de la grille r�guli�re (type : scalaire)
% * p : nombre de niveaux de la grille r�guli�re (type : scalaire)
% * n : rapport delta/taille d'un pas (taille valant 1/(p-1)) ATTENTION :
%   NE PEUT PAS ETRE SUPERIEUR OU EGAL A  p
% * r : nombre de trajectoires (type : scalaire)
% argument en sortie : 
% * vc_selecTraj : la s�lection de r trajectoires (type : vecteur de r cell de matrice k*k+1)
% * v_distance : la distance globale D de cette s�lection de trajectoires
%                (type : scalaire)
vc_selecTraj = F_SelectionTrajectoires(k,p,n,r);
v_sommeDesdAuCarre=0;
for i = 1:r-1
    vv_M4=cellfun(@(x) F_d(vc_selecTraj{i},x),vc_selecTraj(i+1:r));
    v_sommeDesdAuCarre=v_sommeDesdAuCarre+sum(vv_M4.^2);
end
v_distance = sqrt(v_sommeDesdAuCarre);


function v_g=F_d(vm_Btmp_starI,vm_Btmp_starJ)
% calcul de la distance entre 2 trajectoires. pr�-condition : vm_Btmp_starI et vm_Btmp_starJ sont
% deux matrices de trajectoires de m�mes dimensions et de nombre de lignes
% strictement plus grand que leur nombre de colonnes
% arguments en entr�e : les deux trajectoires entre lesquelle on cherche la
%                       la distance mutuelle (type : matrices k*k+1 avec k 
%                       un entier naturel)
% argument en sortie : cette distance (type scalaire)
k = size(vm_Btmp_starI,2);
v_dIJ=0;
for l = 1:k+1
    v_scalaire1=0;
    for m = 1:k+1
        vv_vect=(vm_Btmp_starI(l,:)-vm_Btmp_starJ(m,:)).*(vm_Btmp_starI(l,:)-vm_Btmp_starJ(m,:));
        v_scalaire2=sum(vv_vect);
        v_scalaire1=v_scalaire1+sqrt(v_scalaire2);
    end
    v_dIJ=v_dIJ+v_scalaire1;
end
v_g=v_dIJ;

function vc_g=F_SelectionTrajectoires(k, p,n, r)
% ensemble al�atoire de r trajectoires dans un cell de matrices
% arguments en entr�e :
% * k : dimension de la grille r�guli�re (type : scalaire)
% * p : nombre de niveaux de la grille r�guli�re (type : scalaire)
% * n : rapport delta/taille d'un pas (taille valant 1/(p-1)) ATTENTION :
%   NE PEUT PAS ETRE SUPERIEUR OU EGAL A  p
% * r : nombre de trajectoires (type : scalaire)
% argument en sortie : cet ensemble de trajectoires 
%                     (type : vecteur de r cell de matrice k*k+1)
vc_g=arrayfun(@(x) F_Btmp_star(k,p,n),1:r,'UniformOutput',false);

function vm_Btmp_star=F_Btmp_star(k,p,n)
% cr�ation al�atoire d'une trajectoire
% arguments en entr�e :
% * k : dimension de la grille r�guli�re (tye : scalaire)
% * p : nombre de niveaux de la grille r�guli�re (type : scalaire)
% * n : rapport delta/taille d'un pas (taille valant 1/(p-1)) ATTENTION :
%   NE PEUT PAS ETRE SUPERIEUR OU EGAL A  p
% argument en sortie : cette trajectoire (type : matrice)
v_delta =n./(p-1);
% Ici on a modifi� la formule par rapport � celle de Morris 1991 pour
% prendre en compte des deltas differents selon le facteur : J*xstar n'est
% plus multiplie par Pstar (cela n'etait pas obligatoire puisque xstar est
% al�atoire) et la multiplication par delat est faite apr�s application de
% Pstar pour que les valeurs de deltas ne soient pas permut�es entre les facteurs.
vm_Btmp_star=F_J(k+1,1)*F_x_star(k,p,n)+ repmat(v_delta,k+1,1).*(0.5.*((2.*F_B(k)-F_J(k+1,k))*F_D_star(k)+F_J(k+1,k))*F_P_star(k));

function vv_x_star=F_x_star(k,p,n)
% tirage al�atoire x*
% arguments en entr�e :
% * k : dimension de la grille r�guli�re (type : scalaire)
% * p : nombre de niveaux de la grille r�guli�re (type : scalaire)
% * n : rapport delta/taille d'un pas (taille valant 1/(p-1)) ATTENTION :
% NE PEUT PAS ETRE SUPERIEUR OU EGAL A p
% argument en sortie : x* (type : vecteur)
vv_j = zeros(1,k);
for l = 1:k
    vv_j(l) = randi(p(l)-n(l),1,1);
end
vv_x_star=(vv_j-1).*(1./(p-1));

function vm_B=F_B(k)
% B, matrice strictement triangulaire inf�rieure 
% de taille (k+1,k) dont les �l�ments non nuls valent 1;
% argument en entr�e : k : dimension de la grille r�guli�re
% argument en sortie : B (type : matrice k*k+1)
vm_B = zeros(k+1,k);
for v_i = 2:k+1
    vm_B(v_i,1:v_i-1)=ones(1,v_i-1);
end

function vm_J=F_J(n1,n2)
% matrices dont tous les �l�ments valent 1
% arguments en entr�e : 
% * n1 : nombre de ligne(s) de la matrice (type : scalaire > 0)
% * n2 : nombre de colonne(s) de la matrice (type : scalaire > 0)
% argument en sortie : cette matrice, avec n1 lignes et n2 colonnes
vm_J = ones(n1,n2);

function vm_D_star=F_D_star(k)
% D* matrice diagonale de taille (k,k) et 
% dont les �l�ments valent 1 ou -1, et ce 
% avec une probabilit� �gale et ind�pendante
% entre chaque �l�ment
vm_D_star = diag(randi(2,1,k).*2-3);

function vm_P_star=F_P_star(k)
% P* matrice de permutation de taille(k,k) 
vv_M1 = randsample(k,k)';
vv_M1=vv_M1+(0 : k : k*(k-1));
vm_P_star = zeros(k,k);
vm_P_star(vv_M1)=1;


% % Trac� trajectoire 2D
% traj=Btmp_star(2,6)
% plot(traj(:,1),traj(:,2),'+')
% ylim([0,1])
% xlim([0,1])