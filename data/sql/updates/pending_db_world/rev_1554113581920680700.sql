INSERT INTO `version_db_world` (`sql_rev`) VALUES ('1554113581920680700');

-- Field Marshal Afrasiabi SAI
SET @ENTRY := 14721;
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@ENTRY AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,1,20,0,100,0,7782,0,0,0,80,@ENTRY*100+00,2,0,0,0,0,1,0,0,0,0,0,0,0,'Field Marshal Afrasiabi - On Quest The Lord of Blackrock Finished - Run Script'),
(@ENTRY,0,1,0,61,0,100,0,7782,0,0,0,64,1,0,0,0,0,0,7,0,0,0,0,0,0,0,'Field Marshal Afrasiabi - On Quest The Lord of Blackrock Finished - Store Targetlist');

 -- Actionlist SAI
SET @ENTRY := 1472100;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@ENTRY AND `source_type`=9;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,9,0,0,0,0,100,0,1000,1000,0,0,83,2,0,0,0,0,0,1,0,0,0,0,0,0,0,'Field Marshal Afrasiabi - On Script - Remove Npc Flag Questgiver'),
(@ENTRY,9,1,0,0,0,100,0,5000,5000,0,0,1,0,8000,0,0,0,0,12,1,0,0,0,0,0,0,'Field Marshal Afrasiabi - On Script - Say Line 0'),
(@ENTRY,9,2,0,0,0,100,0,8000,8000,0,0,1,1,10000,0,0,0,0,12,1,0,0,0,0,0,0,'Field Marshal Afrasiabi - On Script - Say Line 1'),
(@ENTRY,9,3,0,0,0,100,0,3000,3000,0,0,50,179882,21600,0,0,0,0,8,0,0,0,-8925.57,496.042,103.767,2.42801,'Field Marshal Afrasiabi - On Script - Summon Gameobject The Severed Head of Nefarian'),
(@ENTRY,9,4,0,0,0,100,0,6000,6000,0,0,11,22888,0,0,0,0,0,1,0,0,0,0,0,0,0,'Field Marshal Afrasiabi - On Script - Cast Rallying Cry of the Dragonslayer'),
(@ENTRY,9,5,0,0,0,100,0,1000,1000,0,0,82,2,0,0,0,0,0,1,0,0,0,0,0,0,0,'Field Marshal Afrasiabi - On Script - Add Npc Flag Questgiver'),
(@ENTRY,9,6,0,1,0,100,0,30000,30000,0,0,41,7200000,0,0,0,0,0,14,0,179882,0,0,0,0,0,'Field Marshal Afrasiabi - Despawn In 10000 ms');

DELETE FROM `creature_text` WHERE `creatureid` IN (14721);
INSERT INTO `creature_text` (`creatureid`, `groupid`, `id`, `text`, `type`, `language`, `probability`, `emote`, `duration`, `sound`, `comment`, `BroadcastTextId`) VALUES 
(14721, 0, 0, 'Citizens of the Alliance, the Lord of Blackrock is slain! Nefarian has been subdued by the combined might of $N and $Ghis:her; allies!', 14, 0, 100, 0, 0, 0, 'Field Marshal Afrasiabi', 9870),
(14721, 1, 0, 'Let your spirits rise! Rally around your champion, bask in $Ghis:her; glory! Revel in the rallying cry of the dragon slayer!', 14, 0, 100, 0, 0, 0, 'Field Marshal Afrasiabi', 9872);
