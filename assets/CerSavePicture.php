<?PHP

$name = $_POST ["name"];
$image = $_POST ["image"];

$decodedImage=base64_decode("$image");
file_put_contents("Photo/Cer_upload_photo/".$name.".JPG" , $decodedImage);

?>
