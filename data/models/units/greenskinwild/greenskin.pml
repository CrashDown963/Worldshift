<?xml version="1.0"?>
<library id="Green_PhysX2" type="physics">
 <scenedesc source="3dsmax">
  <eye>-1.15208 -3.24106 2.50583</eye>
  <gravity>0.0 0.0 -10.0</gravity>
  <lookat>-0.976907 -2.29589 2.2302</lookat>
  <up>0.0 0.0 1.0</up>
 </scenedesc>
 <physicsmodel id="main">
  <rigidbody id="Bip01_Spine">
   <mass>40.0</mass>
   <orientation>0.107728 0.10773 -0.698852 0.698853</orientation>
   <position>0.0 1.47282 1.16643</position>
   <shape id="shape_Bip01_Spine">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_Spine_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <position>0.0 0.0 0.0</position>
    <geometry id="Bip01_Spine_geom">
     <capsule>
      <p0>0.0 0.0 0.2289</p0>
      <p1>0.0 0.0 0.5381</p1>
      <radius>0.2289</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_R_Thigh">
   <mass>15.0</mass>
   <orientation>-0.723823 0.667405 0.161976 -0.0664397</orientation>
   <position>-0.199272 1.47268 1.05184</position>
   <shape id="shape_Bip01_R_Thigh">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_R_Thigh_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_R_Thigh_geom">
     <capsule>
      <p0>0.0 0.0 0.13</p0>
      <p1>0.0 0.0 0.35</p1>
      <radius>0.13</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_R_Calf">
   <mass>6.0</mass>
   <orientation>0.320957 -0.425466 -0.664621 -0.523683</orientation>
   <position>-0.309396 1.53165 0.609541</position>
   <shape id="shape_Bip01_R_Calf">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_R_Calf_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_R_Calf_geom">
     <capsule>
      <p0>0.0 0.0 0.08</p0>
      <p1>0.0 0.0 0.32</p1>
      <radius>0.08</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_L_UpperArm">
   <mass>10.0</mass>
   <orientation>0.652317 0.499139 0.459384 0.338096</orientation>
   <position>0.407483 1.28113 1.71512</position>
   <shape id="shape_Bip01_L_UpperArm">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_L_UpperArm_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_L_UpperArm_geom">
     <capsule>
      <p0>0.0 0.0 0.095</p0>
      <p1>0.0 0.0 0.165</p1>
      <radius>0.095</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_L_Thigh">
   <mass>15.0</mass>
   <orientation>-0.667406 0.723822 -0.0664401 0.161976</orientation>
   <position>0.199272 1.47268 1.05184</position>
   <shape id="shape_Bip01_L_Thigh">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_L_Thigh_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_L_Thigh_geom">
     <capsule>
      <p0>0.0 0.0 0.13</p0>
      <p1>0.0 0.0 0.35</p1>
      <radius>0.13</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_L_Calf">
   <mass>6.0</mass>
   <orientation>-0.425466 0.320957 0.523684 0.66462</orientation>
   <position>0.354043 1.52753 0.620108</position>
   <shape id="shape_Bip01_L_Calf">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_L_Calf_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_L_Calf_geom">
     <capsule>
      <p0>0.0 0.0 0.08</p0>
      <p1>0.0 0.0 0.32</p1>
      <radius>0.08</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_L_HorseLink">
   <mass>4.0</mass>
   <orientation>-0.629536 0.60894 0.242799 0.417044</orientation>
   <position>0.300614 1.94865 0.80929</position>
   <shape id="shape_Bip01_L_HorseLink">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_L_HorseLink_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_L_HorseLink_geom">
     <capsule>
      <p0>0.0 0.0 0.08</p0>
      <p1>0.0 0.0 0.447507</p1>
      <radius>0.08</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_Head">
   <mass>20.0</mass>
   <orientation>0.122787 0.122788 -0.696365 0.696364</orientation>
   <position>3.75629e-007 1.15244 1.86056</position>
   <shape id="shape_Bip01_Head">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_Head_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <position>0.0 1.33514e-007 0.0669579</position>
    <geometry id="Bip01_Head_geom">
     <sphere>
      <radius>0.1508</radius>
     </sphere>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_Pelvis">
   <mass>10.0</mass>
   <orientation>0.0437918 -0.0101316 -0.612723 0.789018</orientation>
   <position>0.0 1.47268 1.05184</position>
   <shape id="shape_Bip01_Pelvis">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_Pelvis_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <position>0.0 0.0 0.0</position>
    <geometry id="Bip01_Pelvis_geom">
     <sphere>
      <radius>0.0295858</radius>
     </sphere>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_R_UpperArm">
   <mass>10.0</mass>
   <orientation>-0.499139 -0.652317 0.338097 0.459384</orientation>
   <position>-0.407482 1.28113 1.71512</position>
   <shape id="shape_Bip01_R_UpperArm">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_R_UpperArm_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_R_UpperArm_geom">
     <capsule>
      <p0>0.0 0.0 0.095</p0>
      <p1>0.0 0.0 0.165</p1>
      <radius>0.095</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_R_Forearm">
   <mass>10.0</mass>
   <orientation>-0.12026 -0.787519 0.590751 -0.127928</orientation>
   <position>-0.638013 1.28543 1.62916</position>
   <shape id="shape_Bip01_R_Forearm">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_R_Forearm_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_R_Forearm_geom">
     <capsule>
      <p0>0.0 0.0 0.1</p0>
      <p1>0.0 0.0 0.47</p1>
      <radius>0.1</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_L_Forearm">
   <mass>10.0</mass>
   <orientation>-0.787519 -0.12026 0.127927 -0.590751</orientation>
   <position>0.638014 1.28543 1.62916</position>
   <shape id="shape_Bip01_L_Forearm">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_L_Forearm_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <position>0.0 0.0 0.0</position>
    <geometry id="Bip01_L_Forearm_geom">
     <capsule>
      <p0>0.0 0.0 0.09</p0>
      <p1>0.0 0.0 0.48</p1>
      <radius>0.09</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_R_HorseLink">
   <mass>4.0</mass>
   <orientation>-0.608941 0.629535 0.417043 0.242799</orientation>
   <position>-0.300614 1.94865 0.809289</position>
   <shape id="shape_Bip01_R_HorseLink">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_R_HorseLink_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_R_HorseLink_geom">
     <capsule>
      <p0>0.0 0.0 0.08</p0>
      <p1>0.0 0.0 0.447507</p1>
      <radius>0.08</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <joint child="#Bip01_R_Thigh" class="novodex" id="Joint_Bip01_R_Thigh" parent="#Bip01_Spine">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.985746 0.00157889 0.168233</x>
    <y>0.0566662 -0.944645 -0.323165</y>
    <z>0.15841 0.328092 -0.931269</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.0346441 -0.199271 -0.10922</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>50.1944 56.3099 37.875</rotlimitmax>
   <rotlimitmin>-50.1944 -56.3099 -31.6075</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_R_Calf" class="novodex" id="Joint_Bip01_R_Calf" parent="#Bip01_R_Thigh">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>-0.245779 -0.398993 -0.883401</x>
    <y>-0.967902 0.0516384 0.245966</y>
    <z>-0.0525214 0.915499 -0.398878</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.0 -0.0400573 0.457855</offset>
    <x>0.916289 -0.400517 0.0</x>
    <y>0.0604612 0.138321 -0.98854</y>
    <z>0.395927 0.905789 0.150958</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 0.0</rotlimitmax>
   <rotlimitmin>0.0 0.0 -17.8434</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_L_UpperArm" class="novodex" id="Joint_Bip01_L_UpperArm" parent="#Bip01_Spine">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>-0.99602 -0.0105132 0.0885069</x>
    <y>0.0796537 0.340559 0.936843</y>
    <z>-0.0399911 0.940164 -0.338366</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.0175569 0.407481 0.580952</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>57.5288 17.3422 33.3251</rotlimitmax>
   <rotlimitmin>-57.5288 -17.3422 -33.6901</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_L_Thigh" class="novodex" id="Joint_Bip01_L_Thigh" parent="#Bip01_Spine">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.985746 -0.0015791 0.168233</x>
    <y>-0.0566674 -0.944642 0.323171</y>
    <z>0.158409 -0.328098 -0.931267</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.0346441 0.199272 -0.109219</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>58.3925 37.5686 41.1859</rotlimitmax>
   <rotlimitmin>-58.3925 -37.5686 -28.3008</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_L_Calf" class="novodex" id="Joint_Bip01_L_Calf" parent="#Bip01_L_Thigh">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>-0.245779 0.398994 -0.883401</x>
    <y>-0.967902 -0.0516359 0.245968</y>
    <z>0.0525243 0.915499 0.398878</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.0 -0.00583202 0.46187</offset>
    <x>0.916289 0.400518 0.0</x>
    <y>0.0604606 -0.138319 -0.988541</y>
    <z>-0.395928 0.905789 -0.150956</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 0.0</rotlimitmax>
   <rotlimitmin>0.0 0.0 -17.7839</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_L_HorseLink" class="novodex" id="Joint_Bip01_L_HorseLink" parent="#Bip01_L_Calf">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>-0.505513 0.0 -0.862819</x>
    <y>0.862819 0.0 -0.505513</y>
    <z>0.0 -1.0 0.0</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.0 0.0460645 0.462454</offset>
    <x>-1.0 0.0 0.0</x>
    <y>0.0 -1.82668e-007 -1.0</y>
    <z>0.0 -1.0 1.82668e-007</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 0.0</rotlimitmax>
   <rotlimitmin>0.0 0.0 -85.0</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_Head" class="novodex" id="Joint_Bip01_Head" parent="#Bip01_Spine">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.999068 2.71943e-006 0.0431555</x>
    <y>-2.61426e-006 1.0 -2.49343e-006</y>
    <z>-0.0431555 2.37829e-006 0.999068</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.0964695 -1.92904e-006 0.758392</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>1.74886 40.0 44.9512</rotlimitmax>
   <rotlimitmin>-1.74886 -40.0 -44.9512</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_Pelvis" class="novodex" id="Joint_Bip01_Pelvis" parent="#Bip01_Spine">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.934207 -0.258466 -0.245873</x>
    <y>0.248933 0.966013 -0.0696551</y>
    <z>0.25552 0.00386637 0.966796</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.0346442 2.72989e-007 -0.10922</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 0.0</rotlimitmax>
   <rotlimitmin>0.0 0.0 0.0</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_R_UpperArm" class="novodex" id="Joint_Bip01_R_UpperArm" parent="#Bip01_Spine">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>-0.99602 0.0105136 0.0885065</x>
    <y>-0.079653 0.340564 -0.936841</y>
    <z>-0.0399917 -0.940163 -0.338371</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.0175569 -0.407484 0.58095</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>55.008 18.5957 42.2737</rotlimitmax>
   <rotlimitmin>-55.008 -18.5957 -35.0667</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_R_Forearm" class="novodex" id="Joint_Bip01_R_Forearm" parent="#Bip01_R_UpperArm">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>-0.0215953 -1.50961e-007 0.999767</x>
    <y>-0.999767 0.0 -0.0215953</y>
    <z>0.0 -1.0 -1.50996e-007</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.0 0.0 0.246072</offset>
    <x>-1.0 -1.50996e-007 0.0</x>
    <y>0.0 0.0 -1.0</y>
    <z>1.50996e-007 -1.0 0.0</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 59.9802</rotlimitmax>
   <rotlimitmin>0.0 0.0 -65.0198</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_L_Forearm" class="novodex" id="Joint_Bip01_L_Forearm" parent="#Bip01_L_UpperArm">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>-0.0215951 0.0 0.999767</x>
    <y>-0.999767 0.0 -0.0215951</y>
    <z>0.0 -1.0 0.0</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>1.71661e-007 0.0 0.246072</offset>
    <x>-1.0 4.20601e-007 0.0</x>
    <y>0.0 -8.43243e-007 -1.0</y>
    <z>-4.20601e-007 -1.0 8.43243e-007</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 55.0</rotlimitmax>
   <rotlimitmin>0.0 0.0 -75.0</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_R_HorseLink" class="novodex" id="Joint_Bip01_R_HorseLink" parent="#Bip01_R_Calf">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>-0.505513 0.0 -0.862819</x>
    <y>0.862819 -2.02226e-007 -0.505513</y>
    <z>-1.73541e-007 -1.0 0.0</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.0 1.52588e-007 0.462454</offset>
    <x>-1.0 6.59572e-007 0.0</x>
    <y>0.0 0.0 -1.0</y>
    <z>-6.59572e-007 -1.0 0.0</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 0.0197823</rotlimitmax>
   <rotlimitmin>0.0 0.0 -84.9802</rotlimitmin>
   <Spring>0</Spring>
  </joint>
 </physicsmodel>
</library>
