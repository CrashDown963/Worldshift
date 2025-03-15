<?xml version="1.0"?>
<library id="Farm-export_game" type="physics">
 <scenedesc source="3dsmax">
  <eye>21.8177 7.87137 15.4899</eye>
  <gravity>0.0 0.0 -10.0</gravity>
  <lookat>20.9783 7.58252 15.0295</lookat>
  <up>0.0 0.0 1.0</up>
 </scenedesc>
 <physicsmodel id="main">
  <rigidbody id="Farm">
   <mass>50.0</mass>
   <orientation>0.0 0.0 0.0 1.0</orientation>
   <position>-0.170076 0.263219 0.0</position>
   <shape id="shape_Farm">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Farm_mat">
     <dynamicfriction>0.9</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>0.9</staticfriction>
    </physicsmaterial>
    <position>0.0 0.0 3.27221</position>
    <geometry id="Farm_geom">
     <box>
      <size>9.8893 9.72644 6.54441</size>
     </box>
    </geometry>
   </shape>
  </rigidbody>
 </physicsmodel>
</library>
