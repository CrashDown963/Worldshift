<?xml version="1.0"?>
<library id="harvester_physX01" type="physics">
 <scenedesc source="3dsmax">
  <eye>5.635 1.90003 3.84398</eye>
  <gravity>0.0 0.0 -10.0</gravity>
  <lookat>4.77917 1.47333 3.55161</lookat>
  <up>0.0 0.0 1.0</up>
 </scenedesc>
 <physicsmodel id="main">
  <rigidbody id="ROOT">
   <mass>150.0</mass>
   <orientation>0.0 0.0 0.0 1.0</orientation>
   <position>-0.0376417 -0.105052 0.0</position>
   <shape id="shape_ROOT">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="ROOT_mat">
     <dynamicfriction>0.4</dynamicfriction>
     <restitution>0.25</restitution>
     <staticfriction>0.4</staticfriction>
    </physicsmaterial>
    <geometry id="ROOT_geom">
     <capsule>
      <p0>0.0 0.0 0.984531</p0>
      <p1>0.0 0.0 3.02409</p1>
      <radius>0.984531</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
 </physicsmodel>
</library>
