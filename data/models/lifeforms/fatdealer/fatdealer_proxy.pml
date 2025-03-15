<?xml version="1.0"?>
<library id="FatDealer_PhysX_Refine" type="physics">
 <scenedesc source="3dsmax">
  <eye>0.365676 -4.69289 1.23556</eye>
  <gravity>0.0 0.0 -10.0</gravity>
  <lookat>0.330863 -3.69593 1.16579</lookat>
  <up>0.0 0.0 1.0</up>
 </scenedesc>
 <physicsmodel id="main">
  <rigidbody id="ROOT">
   <mass>10.0</mass>
   <orientation>0.0 0.0 0.0 1.0</orientation>
   <position>0.000773206 -0.116136 0.0</position>
   <shape id="shape_ROOT">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="ROOT_mat">
     <dynamicfriction>0.25</dynamicfriction>
     <restitution>0.4</restitution>
     <staticfriction>0.25</staticfriction>
    </physicsmaterial>
    <geometry id="ROOT_geom">
     <capsule>
      <p0>0.0 0.0 0.630975</p0>
      <p1>0.0 0.0 1.43415</p1>
      <radius>0.630975</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
 </physicsmodel>
</library>
