<?php

/* ######### Ausgangswerte definieren, insbesondere: Welche Kategorie soll abgebildet werden ($ontologyId) ########### */

// Welche Kategorie soll als Naviagtion dargestellt werden?
$ontologyId = 16341;
$ontologyAdministration = new OntologyAdministration();
$RootNode = $ontologyAdministration->getRootNodeOfOntology($ontologyId);
$ontologyAdministration->readOntology($RootNode, $ontologyId);
// Die OntoNodes zur Abbildung der Naviagtion werden geholt
$nodesOnto = $ontologyAdministration->getOntologyHierarchy()->getElements();

//Ist die per get übergebene DropId eine aus der darzustellenden Taxonomie? (Ist wichtig für, welcher Zweig aufgeklappt sein soll).
if(is_object($nodesOnto[$DropId])){
   $catId = $DropId;
} else {
   $catId = $RootNode;
}

/* #################### Funktion zur Abbildung der Taxonomie (Aufruf unten) ##########################*/

function buildOntologyTree ($DropId,$myNode,$nodes,$ontologyId,$ontologyAdministration,$modRewrite,$showRoot=FALSE,$maxDepth,$firstlast="first") {
  if($myNode->getId()==$DropId){
    $aclass = "active";
  }
  $childArray = $myNode->getChildren();
  while($er <= $myNode->getDepth()){
    $einrueckung .= "\t";
    $er++;
  }
  if ($maxDepth > $myNode->getDepth() AND count ($myNode->getChildren())>0 AND ($myNode->getId()==$DropId OR in_array($myNode->getId(),$nodes[$DropId]->getAncestors()))){
    if($showRoot OR $myNode->getDepth()>0){
      echo $einrueckung."<li class='depth".$myNode->getDepth()." ".$firstlast." ".$aclass." opening'><a href='".$url_anfang.$modRewrite->createLink("showProducts",array ("categoryid"=>$myNode->getId(),"categorytitle"=>$myNode->getName()))."'>".$myNode->getName()."</a>";
    }
    echo "\n".$einrueckung."\t<ul class='expanded'>\n";
    foreach($childArray as $key => $myChild){
      if($key==0){
        $firstlast = "first";
      } elseif ($key== count($childArray)-1) {
        $firstlast = "last";
      } else {
        $firstlast = "";
      }
      buildOntologyTree ($DropId,$nodes[$myChild],$nodes,$ontologyId,$ontologyAdministration,$modRewrite,$showRoot,$maxDepth,$firstlast);
    }
    echo $einrueckung."\t</ul>\n";
  } else {
    echo $einrueckung."<li class='depth".$myNode->getDepth()." ".$firstlast." ".$aclass."'><a href='".$url_anfang.$modRewrite->createLink("showProducts",array ("categoryid"=>$myNode->getId(),"categorytitle"=>$myNode->getName()))."'>".$myNode->getName()."</a>";
  }
  if($showRoot OR $myNode->getDepth()>0){
  echo "</li>\n";
  }

}


/* #################### Ab hier: Aussehen des Onto-Naviagtion-Baums definieren ##########################*/

/* Je nachdem, ob man das angezeigt haben will...
$ueberschrift = "<h4>Kategorie: ".$SiteAdministration->getDropById($ontologyId)->getName()."</h4>";

if (HEADLINEIMAGERENDERING == "true") {
  echo headlineImageRendering($ueberschrift, $accessibility->getFontSizeCSS());
}
else {
  echo $ueberschrift;
}
*/

echo "<ul class='ontonav'>";

//Mit diesem Wert wird der Funktion mitgegeben, ob die Root-Kategorie angezeigt werden soll
$showRoot = FALSE;

//Mit diesem Wert wird der Funktion mitgegeben, welche Tiefe maximal angezeigt werden soll
$maxDepth = 2;

//oben definiert:
echo buildOntologyTree($catId,$nodesOnto['16342'],$nodesOnto,$ontologyId,$ontologyAdministration,$modRewrite,$showRoot,$maxDepth,'first');

echo "</ul>";
?>

