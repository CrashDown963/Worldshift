<?xml version="1.0"?>
<library id="SmallCrateGeom3_Exprt" type="physics">
 <scenedesc source="3dsmax">
  <eye>-1.77767 -2.53903 2.2053</eye>
  <gravity>0.0 0.0 -10.0</gravity>
  <lookat>-1.27383 -1.84557 1.69026</lookat>
  <up>0.0 0.0 1.0</up>
 </scenedesc>
 <physicsmodel id="main">
  <rigidbody id="SmallCrate">
   <mass>50.0</mass>
   <orientation>0.0 0.0 0.0 1.0</orientation>
   <position>0.0 0.0 0.0</position>
   <shape id="shape_SmallCrate">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="SmallCrate_mat">
     <dynamicfriction>0.8</dynamicfriction>
     <restitution>0.4</restitution>
     <staticfriction>0.8</staticfriction>
    </physicsmaterial>
    <position>0.0 0.0 0.5</position>
    <geometry id="SmallCrate_geom">
     <box>
      <size>1.0 1.0 1.0</size>
     </box>
    </geometry>
   </shape>
  </rigidbody>
 </physicsmodel>
</library>
