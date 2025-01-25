<?php
if(isset($_GET['aid'])) $aid = $_GET['aid'];
else $aid = $session->alliance;

$varmedal = $database->getProfileMedalAlly($aid);

$allianceinfo = $database->getAlliance($aid);
$memberlist = $database->getAllMember($aid);
//$alliancestendard = $database->getAlliancestendard($aid);
$stendard = $alliancestendard['img'];
if (($stendard =='')or($stendard >55)) {$stendard =0;}
$totalpop = 0;
if($allianceinfo['tag']==""){
	header("Location: allianz.php");
	exit;
}
$memberIDs = [];
foreach($memberlist as $member) {
    $memberIDs[] = $member['id'];
}
$data = $database->getVSumField($memberIDs,"pop");

if (count($data)) {
    foreach ($data as $row) {
        $totalpop += $row['Total'];
    }
}

echo "<h1>".$allianceinfo['tag']." - ".$allianceinfo['name']."</h1>";

$profiel="".$allianceinfo['notice']."".md5('skJkev3')."".$allianceinfo['desc']."";
require("medal.php");
$profiel=explode("".md5('skJkev3')."", $profiel);

include("alli_menu.tpl");

?>
<table cellpadding="1" cellspacing="1" id="profile">
<thead>
<tr>
<th colspan="2"><?php echo ALLIANCE;?></th>
</tr>
<tr>
<td><?php echo DETAIL; ?></td>
<td><?php echo DESCRIPTION; ?></td>

</tr>
</thead>
<tbody>
<tr><td class="empty"></td><td class="empty"></td></tr>
<tr>
    <td class="details">
        <table cellpadding="0" cellspacing="0">
            <tr>
                <th><?php echo TAG; ?></th>
                <td><?php echo $allianceinfo['tag']; ?></td>
            </tr>
            <tr>
                <th><?php echo NAME; ?></th>
                <td><?php echo $allianceinfo['name']; ?></td>
            </tr>
               
            <tr>
                <th><?php echo Rank; ?></th>
                <td><?php echo $ranking->getAllianceRank($aid); ?>.</td>
            </tr>
            <tr>
                <th><?php echo POINTS; ?></th>
                <td><?php echo $totalpop; ?></td>
            </tr>
            <tr>
                <th><?php echo PLAYERS; ?></th>
                <td><?php echo count($memberlist); ?></td>
            </tr>
            <tr>
                <th><?php echo "Max. ".PLAYERS; ?></th>
                <td><?php echo $allianceinfo['max']; ?></td>
            </tr>
            <tr>
                    <td colspan="2" class="empty"></td>
                </tr>
                <?php
                foreach($memberlist as $member) {

                //rank name
                $rank = $database->getAlliancePermission($member['id'],"rank",0);

                //username
                $name = $database->getUserField($member['id'],"username",0);

                //if there is no rank defined, user will not be printed
                if($rank == ''){
                echo '';
                }

                //if there is user rank defined, user will be printed
                else if($rank != ''){
                echo "<tr>";
                echo "<th>".stripslashes($rank)."</th>";
                echo "<td><a href='spieler.php?uid=".$member['id']."'>".$name."</td>";
                echo "</tr>";
                }
				}
			if($allianceinfo['forumlink'] != '' && $allianceinfo['forumlink'] != '0'){
                echo "<tr>";
                echo "<td><a href='".$allianceinfo['forumlink']."'>» to the forum</td>";
                echo "</tr>";
                }else{
			?>
                <tr>
                <td colspan="2" class="emmty"></td>
            </tr>
			<?php } ?>
            <tr>
                <td class="desc2" colspan="2">
                    <div class="desc2div"><?php echo stripslashes(nl2br($profiel[0])); ?></div>
                </td>
            </tr>
            </table>
    </td>
    <td class="desc1">
        <div class="desc1div"><?php echo stripslashes(nl2br($profiel[1])); ?></div>
    </td>
</tr>
</tbody>
</table><table cellpadding="1" cellspacing="1" id="member"><thead>
<tr>
<th>&nbsp;</th>
<th><?php echo PLAYER; ?></th>
<th>Tribes</th>
<!--<th>⚡</th>-->
<th><?php echo POP; ?></th>
<th><?php echo MULTI_V_HEADER; ?></th>
<?php
//if($aid == $session->alliance && ALLIANCEBYSYSTEM == false)
if($aid == $session->alliance){
     echo "<th>&nbsp;</th>";
}
?>
</tr>
</thead>
<tbody>
<?php
// Alliance Member list loop
$rank=0;

// preload villages data
$userIDs = [];
foreach($memberlist as $member) {
    $userIDs[] = $member['id'];
}
$database->getProfileVillages($userIDs);

$TotalUserPopCrossTribe = 0;
$tribeArraysTotalPop = [0, 0, 0, 0, 0, 0, 0, 0, 0];

// continue...
foreach($memberlist as $member) {

    $rank = $rank+1;
    $TotalUserPop = $database->getVSumField($member['id'],"pop");
    $TotalVillages = $database->getProfileVillages($member['id']);
    $playerData = $database->getAlliPermissions($session->uid, $aid);
    $tribeArrays = [TRIBE1, TRIBE2, TRIBE3, TRIBE4, TRIBE5, TRIBE6];

    $TotalUserPopCrossTribe += $TotalUserPop * count($TotalVillages); //Statistiche
    $tribeArraysTotalPop[$member['tribe'] - 1] += $TotalUserPop * count($TotalVillages); //Statistiche

    echo "    <tr>";
    echo "    <td class=ra>".$rank.".</td>";
    echo "    <td class=pla><a href=spieler.php?uid=".$member['id'].">".$member['username']."</a></td>";
    echo "    <td class=hab>".$tribeArrays[$member['tribe'] - 1]."</td>";
    /* if ($member['god'] == 1) {
            echo '<td class=pla><center><img src="gpack/travian_default/img/gods/Hera.png" height="15" alt="Hera" title="Hera"></center></td>';
	  }elseif ($member['god'] == 2) {
            echo '<td class=pla><center><img src="gpack/travian_default/img/gods/Ares.png" height="15" alt="Ares" title="Ares"></center></td>';
	  }elseif ($member['god'] == 3) {
            echo '<td class=pla><center><img src="gpack/travian_default/img/gods/Athena.png" height="15" alt="Athena" title="Athena"></center></td>';
	  }elseif ($member['god'] == 4) {
            echo '<td class=pla><center><img src="gpack/travian_default/img/gods/Artemis.png" height="15" alt="Artemis" title="Artemis"></center></td>';
	  }elseif ($member['god'] == 0) {
            echo '<td class=pla><center></center></td>';
	  } */
    echo "    <td class=hab>".$TotalUserPop."</td>";
    echo "    <td class=vil>".count($TotalVillages)."</td>";

    //if($aid == $session->alliance && ALLIANCEBYSYSTEM == false)
	if($aid == $session->alliance){
        if ( $playerData['opt4'] == 1 )
        {         
            if ((time()-600) < $member['timestamp']){ // 0 Min - 10 Min
                echo "    <td class=on><img class=online1 src=img/x.gif title='Now online' alt='Now online' /></td>";
            }elseif ((time()-86400) < $member['timestamp'] && (time()-600) > $member['timestamp']){ // 10 Min - 1 Days
                echo "    <td class=on><img class=online2 src=img/x.gif title='Offline' alt='Offline' /></td>";
                }elseif ((time()-259200) < $member['timestamp'] && (time()-86400) > $member['timestamp']){ // 1-3 Days
                echo "    <td class=on><img class=online3 src=img/x.gif title='Last 3 days' alt='Last 3 days' /></td>";
            }elseif ((time()-604800) < $member['timestamp'] && (time()-259200) > $member['timestamp']){
                echo "    <td class=on><img class=online4 src=img/x.gif title='Last 7 days' alt='Last 7 days' /></td>";
            }else{
                 echo "    <td class=on><img class=online5 src=img/x.gif title=inactive alt=inactive /></td>";
            }
        }
        else {
             echo "    <td class=on><font color='red'>🚫</font></td>";
        }

    }

    echo "    </tr>";
}

 //Statistiche:
/*
 echo '<tr><td colspan="100%" class="empty"></td></tr>';
echo "<tr><td colspan='100%'>";
echo " » ".TRIBE1.": <b>".round($tribeArraysTotalPop[0]/$TotalUserPopCrossTribe*100)."%</b> ";
echo " - ".TRIBE2.": <b>".round($tribeArraysTotalPop[1]/$TotalUserPopCrossTribe*100)."%</b> ";
echo " - ".TRIBE3.": <b>".round($tribeArraysTotalPop[2]/$TotalUserPopCrossTribe*100)."%</b> ";
echo " « </td></tr>";

echo "<tr><td colspan='100%'>";
echo " » ".TRIBE4.": <b>".round($tribeArraysTotalPop[3]/$TotalUserPopCrossTribe*100)."%</b> ";
echo " - ".TRIBE5.": <b>".round($tribeArraysTotalPop[4]/$TotalUserPopCrossTribe*100)."%</b> ";
echo " « </td></tr>";
*/

?>
</tbody>
</table>
