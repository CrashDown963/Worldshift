<?xml version="1.0"?>
<library id="ControlTower_destruction01" type="physics">
 <scenedesc source="3dsmax">
  <eye>-53.617 1.65039 32.5869</eye>
  <gravity>0.0 0.0 -10.0</gravity>
  <lookat>-52.6975 1.61801 32.1952</lookat>
  <up>0.0 0.0 1.0</up>
 </scenedesc>
 <physicsmodel id="main">
  <rigidbody id="ROOT">
   <mass>100.0</mass>
   <orientation>0.0 0.0 0.0 1.0</orientation>
   <position>0.0 0.0 0.0</position>
   <shape id="shape_ROOT">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="ROOT_mat">
     <dynamicfriction>0.4</dynamicfriction>
     <restitution>0.2</restitution>
     <staticfriction>0.4</staticfriction>
    </physicsmaterial>
    <geometry id="ROOT_geom">
     <capsule>
      <p0>0.0 0.0 4.20622</p0>
      <p1>0.0 0.0 16.2244</p1>
      <radius>4.20622</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
 </physicsmodel>
</library>
