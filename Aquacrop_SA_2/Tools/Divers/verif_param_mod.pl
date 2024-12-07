#!/usr/bin/perl

# Ce script compare la liste des parametres de STICS présents dans le fichier param.mod avec celle traitee dans le fichier lecoptim.for et affiche (format csv) les parametres qui ne sont pas présents dans les 2 listes et leurs eventuelles differences de numerotation.
# Il prend 2 arguments optionnels en entrée : les chemins (sans les noms des fichiers) vers les fichiers param.mod et lecoptim.for (dans cet ordre, et AVEC un / ou \ à la fin selon l'OS).
# Si ces 2 arguments ne sont pas fournis, le script cherchera les fichiers dans le répertoire dans lequel il est exécuté.
# Si les 2 fichiers ne sont pas dans le répertoire d'exécution mais sont dans le même rpertoire, un seul argument suffit. 
#
# Pour l'executer : 
#   - sous UNIX : ./verif_param_mod.pl [path_parammod path_lecoptim] > fichier_sortie.csv
#   - sous Windows, dans une fenêtre de commande DOS (perl doit être installé) : perl verif_param_mod.pl [path_parammod path_lecoptim] > fichier_sortie.csv
# 
# S. Buis, le 12/05/2011

# Traitement des arguments du script
if (scalar(@ARGV)==1) {
  $path_parammod=$ARGV[0]."param.mod";
  $path_lecoptim=$ARGV[0]."lecoptim.for";
} elsif (scalar(@ARGV)==2) {
  $path_parammod=$ARGV[0]."param.mod";
  $path_lecoptim=$ARGV[1]."lecoptim.for";
} else {
  $path_parammod="param.mod";
  $path_lecoptim="lecoptim.for";
}

# lecture et traitement du fichier lecoptim
open(fic,'<'.$path_lecoptim) or die $path_lecoptim." : probleme a l ouverture du fichier";
@contenu_fichier=<fic>;
close(fic);

# Recherche de toutes les lignes non commentees qui contienneent numpar(i).eq. et extraction du numero du parametre (zone entre () dans l'expr. reg). map permet d'appliquer la commande ~m a l'ensemble des elements de la liste @contenu_fichier.
@num_param=map($_=~m/^\s*if\s*\(\s*numpar\s*\(i\)\s*\.eq\.\s*(\d+)/,@contenu_fichier);
#  print join("\n",@num_param);

# Recherche de toutes les lignes non commentees qui contiennent ***=valparopt(i) et extraction des noms des parametres
@liste_param=map($_=~m/^\s*(\S+)\s*=\s*valparopt\s*\(i\)/,@contenu_fichier);
# print join("\n",@liste_param);

# On enleve ce qui pollue les noms des parametres
map($_=~s/,variete\(ipl\)//,@liste_param);  # on enleve variete(ipl) dans le nom du param
map($_=~s/\(ipl\)//,@liste_param);  # on enleve (ipl) dans le nom du param
map($_=~s/ipl,//,@liste_param);  # on enleve ipl, dans le nom du param
# print join("\n",@liste_param);

# Comparaison des tailles de num_param et liste_param
if (($taille_numpar=@num_param) != ($taille_nompar=@liste_param)) {
  die "Les listes des numeros et des noms des parametres issues de lecoptim n ont pas la meme taille !!! : taille num_param=".($taille_numpar=@num_param)." ; taille liste_param=".($taille_nompar=@liste_param);
 } 

# Creation d'une table de hash qui associe nom du param et numero pour lecoptim et d'une autre qui fait l'inverse
$count=0;
foreach $param (@liste_param) {
  $hash_param_lecoptim{$param}=@num_param[$count];
  $hash_num_param_lecoptim{@num_param[$count]}=$param;
  $count=$count+1;
}

# Traitement du fichier param.mod et comparaison avec la liste issue de lecoptim
open(fic,'<'.$path_parammod) or die $path_parammod." : probleme a l ouverture du fichier";
@tmp=<fic>;
close(fic);
$taille_param_mod=@tmp;
for ($i=0;$i<$taille_param_mod;$i++){   # on ne garde que la ligne contenant les noms des parametres
  !($i%2) and push(@contenu_fichier_param_mod,@tmp[$i]);
}
map($_=~s/\n//,@contenu_fichier_param_mod); # on enleve les retour chariot
map($_=~s/\s//,@contenu_fichier_param_mod);  # on enleve les espaces
# print join("\n",@contenu_fichier_param_mod);

# Creation des tables de hash pour param.mod et Recherche des parametres qui sont dans param.mod et pas dans lecoptim.for
$count=0;
foreach $line (@contenu_fichier_param_mod) {
   $hash_param_mod{$line}=$count;
   $hash_num_param_mod{$count}=$line;
   $count=$count+1;
   if (!exists($hash_param_lecoptim{$line})) {
     push(@manquant,$line);
   } elsif ($hash_param_lecoptim{$line}!=$hash_param_mod{$line}) {
     push(@pb_numero,$line.";".$hash_param_lecoptim{$line}.";".$hash_param_mod{$line});
   }
}
if ($taille=@manquant>0) {
  print "Liste des parametres qui sont dans param\.mod mais pas dans lecoptim\.for : \n\n";
  print "Nom du parametre dans param\.mod;Numero du parametre dans param\.mod;Nom du parametre correspondant a ce numero dans lecoptim\.for\n";
  foreach $param (@manquant) {
    print $param.";".$hash_param_mod{$param}.";".$hash_num_param_lecoptim{$hash_param_mod{$param}}."\n";  
  }
} else {
  print "Tous les parametres de param.mod sont dans lecoptim.for";
}
print "\n\n";

# Recherche des parametres qui sont dans lecoptim et pas dans param.mod
foreach $param (@liste_param) {
   if (!exists($hash_param_mod{$param})) {
     push(@manquant_param_mod,$param);
   }
}
if ($taille=@manquant_param_mod>0) {
  print "Liste des parametres qui sont dans lecoptim\.for mais pas dans param\.mod : \n\n";
  print "Nom du parametre dans lecoptim\.for;Numero du parametre dans lecoptim\.for;Nom du parametre correspondant a ce numero dans param\.mod\n";
  foreach $param (@manquant_param_mod) {
    print $param.";".$hash_param_lecoptim{$param}.";".$hash_num_param_mod{$hash_param_lecoptim{$param}}."\n"; 
  } 
} else {
  print "Tous les parametres de lecoptim.for sont dans param.mod";
}

print "\n\n";

if ($taille=@pb_numero>0) {
  print "Les parametres suivants n\'ont pas le meme numero dans lecoptim\.for et param\.mod : \n";
  print join("\n",@pb_numero);
  print "\n\n";
} else {
  print "Les parametres contenus dans les deux fichiers ont des numeros identiques.\n\n"
}
