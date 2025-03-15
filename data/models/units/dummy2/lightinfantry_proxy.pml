<?xml version="1.0"?>
<library id="NewPhysXLightInfSHIT" type="physics">
 <scenedesc source="3dsmax">
  <eye>-1.30575 -3.60526 1.65423</eye>
  <gravity>0.0 0.0 -10.0</gravity>
  <lookat>-0.993763 -2.67282 1.47199</lookat>
  <up>0.0 0.0 1.0</up>
 </scenedesc>
 <physicsmodel id="main">
  <rigidbody id="Bip01_Pelvis">
   <mass>0.1</mass>
   <orientation>-5.28239e-007 0.0 -0.707106 0.707108</orientation>
   <position>0.0 0.0 0.985545</position>
   <shape id="shape_Bip01_Pelvis">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_Pelvis_mat">
     <dynamicfriction>0.9</dynamicfriction>
     <restitution>0.2</restitution>
     <staticfriction>0.9</staticfriction>
    </physicsmaterial>
    <position>0.0 0.0 -0.945954</position>
    <geometry id="Bip01_Pelvis_geom">
     <capsule>
      <p0>0.0 0.0 0.477559</p0>
      <p1>0.0 0.0 1.41435</p1>
      <radius>0.477559</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
 </physicsmodel>
</library>
