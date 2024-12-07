function outFile = F_gen_xml_file(vs_xml_struct,v_xml_file_name,...
    v_xsl_file,v_type,v_root,v_xsl_st,v_xsl_tr,v_html)
%F_GEN_XML_FILE Generation d'un fichier xml a partir d'une structure
%
%   F_gen_xml_file(vs_xml_struct,v_xml_file_name,v_xsl_file,v_type,
%   v_root)
%  
%   ENTREE(S): descriptif des arguments d'entree
%      - vs_xml_struct : structure (avec eventuellement des champs
%      ATTRIBUTE et CONTENT)
%      - v_xml_file_name: nom du fichier xml a produire
%      - v_xsl_file: nom du fichier xsl pour une transformation eventuelle
%      du fichier xml produit a partir de la structure d'entree
%      - v_type : 'file' pour produire un fichier complet
%      - v_root : nom de la racine de la structure du fichier xml
%      - v_xsl_st : true, lien feuille de style ou non (false, defaut)
%      - v_xsl_tr : true, execution d'une transformation ou non (false)
%      - v_html : true, format de fichier html, false sinon
%  
%   SORTIE(S): 
%      - outFile : objet xmlDocument
%      - fichier xml complet ou contenant un bloc xml
%  
%   CONTENU: 
%  
%   APPEL(S): liste des fonctions appelees
%      - 
%  
%   EXEMPLE(S): cas d'utilisation de la fonction
%      - F_gen_xml_file(vs_xml_struct,'fichier.xml','tranfo.xsl')
%  
%  AUTEUR(S): P. Lecharpentier
%  DATE: 26-Jul-2010
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-05-17 14:35:13 +0200 (ven., 17 mai 2013) $
%    $Author: plecharpent $
%    $Revision: 894 $
%  
%  
% See also xslt, xml_formatany
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A REVOIR : gestion des arguments pour rendre certains optionnels v_type,
% v_root et v_xsl_file...
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Initialisation options
v_complete=true; % generation fichier complet 
v_root_name='root';
v_xsl_style=false;
v_xsl_transform=true;
v_html_output=false;

if nargin<3
    v_xsl_file='';
end
% autre valeur 'file' pour generation du fichier complet
if nargin>3 && strcmp(v_type,'file')
    v_complete=true;
end
if nargin>4
    v_root_name=v_root;
end
% utilisation d'une feuille de style    
if nargin>5
    v_xsl_style=v_xsl_st;
end
% transformation ou non du xml
if nargin>6
    v_xsl_transform=v_xsl_tr;
end
% transformation complete au format html
if nargin>7
    v_html_output=v_html;
end

configFile=configDocument(vs_xml_struct);
configFile=configFile.setName('temp_conf.xml'); 
configFile=configFile.setXslResource(v_xsl_file);
configFile=configFile.setRoot(v_root_name);
configFile.writeToFile('temp_conf.xml',v_xsl_style);

% Si transformation
if v_xsl_transform && exist(v_xsl_file,'file')
    try 
        if v_html_output% format html demande
            vs_fparts=F_file_parts(v_xml_file_name);
            % Modif extension du fichier pour prod. html
            v_xml_file_name=fullfile(vs_fparts.dir,[vs_fparts.name '.html']);
        end
        % transformation du fichier (en xml ou html)
        % 
        configFile.toFile(v_xml_file_name);
    catch parsingError
        F_create_message(v_xml_file_name,'Erreur lors de la transformation du fichier !',1,1,parsingError);
    end
    % pour un traitement partiel: NON TESTE !!!!!!!
    if ~v_complete
		partFile=xmlDocument(v_xml_file_name).open;
        vc_xml_text=textscan(partFile.Fid,'%s','Delimiter','\n');
        partFile.close;
        vc_xml_text=vc_xml_text{1};
        vc_xml_text=vc_xml_text(3:(end-1));
		partFile=partFile.open('w');
        fprintf(partFile.Fid,'%s\n',vc_xml_text{:});
        partFile.close;
    end
else
    % pas de transformation, simple copie avec le nom specifie
    configFile.fcopy(v_xml_file_name);
end

% Effacement du fichier temporaire
configFile.delete;

% Objet de retour
outFile=configFile.setName(v_xml_file_name);

