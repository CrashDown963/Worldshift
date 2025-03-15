<?xml version="1.0"?>
<library id="BD_Drone_Rig_low" type="physics">
 <scenedesc source="3dsmax">
  <eye>0.47423 -1.65179 0.486276</eye>
  <gravity>0.0 0.0 -10.0</gravity>
  <lookat>0.224794 -0.710599 0.258503</lookat>
  <up>0.0 0.0 1.0</up>
 </scenedesc>
 <physicsmodel id="main">
  <rigidbody id="Drone_Body">
   <mass>9.0</mass>
   <orientation>0.0 0.0 0.0 1.0</orientation>
   <position>0.0 0.0 0.29334</position>
   <shape id="shape_Drone_Body">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Drone_Body_mat">
     <dynamicfriction>0.4</dynamicfriction>
     <restitution>0.4</restitution>
     <staticfriction>0.4</staticfriction>
    </physicsmaterial>
    <geometry id="Drone_Body_geom">
     <sphere>
      <radius>0.18495</radius>
     </sphere>
    </geometry>
   </shape>
  </rigidbody>
 </physicsmodel>
</library>
