#!/usr/bin/perl

# Ce script compare la liste des variables de sortie de STICS pr�sentes dans le fichier vartot.mod avec celle traitee dans le fichier lecsorti.for et affiche les variables qui ne sont pas pr�sentes dans les 2 listes. Elle compare �galement var.mod et vartot.mod et affiche la liste des variables pr�sente dans le var.mod et qui ne sont pas dans vartot.mod.
# Il prend 2 arguments optionnels en entr�e : les chemins (sans les noms des fichiers) vers les fichiers vartot.mod/var.mod et lecsorti.for (dans cet ordre, et AVEC un / ou \ � la fin selon l'OS).
# Si ces 2 arguments ne sont pas fournis, le script les cherchera dans le r�pertoire dans lequel il est ex�cut�.
# Si les 2 fichiers ne sont pas dans le r�pertoire d'ex�cution mais sont dans le m�me rpertoire, un seul argument suffit. 
# 
# Pour l'executer : 
#   - sous UNIX : ./verif_vartot_mod.pl [path_vartot path_lecsorti]
#   - sous Windows, dans une fen�tre de commande DOS (perl doit �tre install�) : perl verif_vartot_mod.pl [path_vartot path_lecsorti]
# 
# S. Buis, le 12/05/2011


# Traitement des arguments du script
if (scalar(@ARGV)==1) {
  $path_vartot=$ARGV[0]."vartot.mod";
  $path_var=$ARGV[0]."var.mod";
  $path_lecsorti=$ARGV[0]."lecsorti.for";
} elsif (scalar(@ARGV)==2) {
  $path_vartot=$ARGV[0]."vartot.mod";
  $path_var=$ARGV[0]."var.mod";
  $path_lecsorti=$ARGV[1]."lecsorti.for";
} else {
  $path_vartot="vartot.mod";
  $path_var="var.mod";
  $path_lecsorti="lecsorti.for";
}

# Lecture et traitement du fichier lecsorti.for
open(fic,'<'.$path_lecsorti) or die $path_lecsorti." : probleme a l ouverture du fichier";
@contenu_fichier=<fic>;
close(fic);

$flag=0;
foreach $line (@contenu_fichier) {
  if ($line=~m/^      data /) {
    @tmp=($line=~m/'(\S+)'/);
    @tmp=split(/','/,@tmp[0]);   # je n'arrive pas au-dessus � s�parer les diff�rents parametres, d'ou cette etape ...
#    print join("\n",@tmp);
    push(@liste_param,@tmp);
    $flag=1;
  } elsif ($flag==1 && $line=~m/^     \S/) {
    @tmp=($line=~m/'(\S+)'/);
    @tmp=split(/','/,@tmp[0]);
#    print join("\n",@tmp);
    push(@liste_param,@tmp);    
  } else {
    $flag=0;
  }
}
foreach $param (@liste_param) {
  $liste_param_lecsorti{$param}=$param;
}
# print "Liste des param�tres du fichier lecsorti.for\n".join("\n",keys(%liste_param_lecsorti));


# Lecture et traitement du fichier vartot.mod
open(fic,'<'.$path_vartot) or die $path_vartot." : probleme a l ouverture du fichier";
@contenu_fichier=<fic>;
close(fic);
$flag=0;
foreach $line (@contenu_fichier) {
  @tmp=split(/\s+/,$line);
  $liste_param_vartot{$tmp[0]}=$tmp[0];
}
# print "Liste des param�tres du fichier vartot.mod\n".join("\n",keys(%liste_param_vartot));

# Lecture et traitement du fichier var.mod
open(fic,'<'.$path_var) or die $path_var." : probleme a l ouverture du fichier";
@contenu_fichier=<fic>;
close(fic);
$flag=0;
foreach $line (@contenu_fichier) {
  @tmp=split(/\s+/,$line);
  $liste_param_var{$tmp[0]}=$tmp[0];
}
# print "Liste des param�tres du fichier var.mod\n".join("\n",keys(%liste_param_var));



# Recherche des parametre de vartot.mod absent de lecsorti.for
foreach $line (keys(%liste_param_vartot)) {
   if (!exists($liste_param_lecsorti{$line})) {
     push(@manquant,$line);
   }
}
if ($taille=@manquant>0) {
  print "Les parametres suivants sont dans vartot.mod mais pas dans lecsorti\.for : \n";
  print join(",",@manquant);
} else {
  print "Tous les parametres de vartot.mod sont dans lecsorti.for";
}
print "\n\n";

# Recherche des parametres de lecsorti.for absent de vartot.mod
foreach $line (keys(%liste_param_lecsorti)) {
   if (!exists($liste_param_vartot{$line})) {
     push(@manquant_vartot,$line);
   }
}
if ($taille=@manquant_vartot>0) {
  print "Les parametres suivants sont dans lecsorti\.for mais pas dans vartot.mod : \n";
  print join(",",@manquant_vartot);
} else {
  print "Tous les parametres de lecsorti.for sont dans vartot.mod";
}
print "\n\n";

# Recherche des parametre de var.mod absent de vartot.mod
foreach $line (keys(%liste_param_var)) {
   if (!exists($liste_param_vartot{$line})) {
     push(@manquant_var,$line);
   }
}
if ($taille=@manquant_var>0) {
  print "Les parametres suivants sont dans var.mod mais pas dans vartot.mod : \n";
  print join(",",@manquant_var);
} else {
  print "Tous les parametres de var.mod sont dans vartot.mod";
}
print "\n\n";

