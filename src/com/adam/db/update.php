<?php

echo 'updateClient<br>';

include 'connString.php';

$title=$_POST['title'];
$des=mysql_real_escape_string($_POST['description']);
$link=$_POST['link'];
$id=$_POST['id'];
$icon=$_POST['icon'];
$dCompleted=$_POST['dCompleted'];
if(stripos($dCompleted,"-")){
	//echo stripos($dCompleted, "-");
	
} else {
	$dCompleted=date("Y-m-d", strtotime($dCompleted));
}
//echo $dCompleted;
$dViewable=$_POST['dViewable'];
if(stripos($dViewable,"-")){
	//echo stripos($dViewable, "-");
	
} else {
	$dViewable=date("Y-m-d", strtotime($dViewable));
}
//$delete=$_POST['delete'];

//echo $id."<br>";
//echo $des."<br>";
foreach($_POST as $key => $item){echo $key." ".$item."<br>";}

if(isset($_POST['delete'])){
	echo "delete checked<br>";
	$sql="DELETE FROM client WHERE id=".$id;
} else {
	$sql="UPDATE client SET title ='".$title."', description = '".$des."', link = '".$link."', icon = '".$icon."', dCompleted = '".$dCompleted."', dViewable = '".$dViewable."' WHERE id= ".$id;
	echo "delete not checked<br>";
}

echo $sql."<br>";

if (!mysql_query($sql,$conn)) {
  	die('Error: ' . mysql_error());
} else {
	echo "record modified";
}


mysql_close($conn)

?>