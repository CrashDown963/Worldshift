<?xml version="1.0"?>
<library id="Sorcerer_physX_only" type="physics">
 <scenedesc source="3dsmax">
  <eye>1.06433 -11.8674 3.62732</eye>
  <gravity>0.0 0.0 -10.0</gravity>
  <lookat>0.970094 -10.8887 3.44507</lookat>
  <up>0.0 0.0 1.0</up>
 </scenedesc>
 <physicsmodel id="main">
  <rigidbody id="Bip01_Spine02">
   <mass>40.0</mass>
   <orientation>0.0339512 0.0370395 -0.736238 0.674855</orientation>
   <position>-0.0328886 -0.12453 1.10481</position>
   <shape id="shape_Bip01_Spine02">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_Spine02_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <position>0.0 0.0 0.0</position>
    <geometry id="Bip01_Spine02_geom">
     <capsule>
      <p0>0.0 0.0 0.21</p0>
      <p1>0.0 0.0 0.4331</p1>
      <radius>0.21</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_R_Thigh01">
   <mass>20.0</mass>
   <orientation>-0.657987 0.7488 0.0460091 0.0650854</orientation>
   <position>-0.130412 -0.159603 1.19428</position>
   <shape id="shape_Bip01_R_Thigh01">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_R_Thigh01_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_R_Thigh01_geom">
     <capsule>
      <p0>0.0 0.0 0.13</p0>
      <p1>0.0 0.0 0.47</p1>
      <radius>0.13</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_R_Calf01">
   <mass>10.0</mass>
   <orientation>0.6559 -0.745967 -0.0696956 -0.0920332</orientation>
   <position>-0.108328 -0.0671702 0.603815</position>
   <shape id="shape_Bip01_R_Calf01">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_R_Calf01_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_R_Calf01_geom">
     <capsule>
      <p0>0.0 0.0 0.12</p0>
      <p1>0.0 0.0 0.51</p1>
      <radius>0.12</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_L_Thigh01">
   <mass>20.0</mass>
   <orientation>-0.749393 0.657065 -0.0275043 0.0769382</orientation>
   <position>0.121171 -0.158565 1.18756</position>
   <shape id="shape_Bip01_L_Thigh01">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_L_Thigh01_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_L_Thigh01_geom">
     <capsule>
      <p0>0.0 0.0 0.13</p0>
      <p1>0.0 0.0 0.47</p1>
      <radius>0.13</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_L_Calf01">
   <mass>10.0</mass>
   <orientation>-0.747332 0.643218 0.0619788 0.154677</orientation>
   <position>0.206293 -0.111217 0.597491</position>
   <shape id="shape_Bip01_L_Calf01">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_L_Calf01_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_L_Calf01_geom">
     <capsule>
      <p0>0.0 0.0 0.12</p0>
      <p1>0.0 0.0 0.51</p1>
      <radius>0.12</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_L_UpperArm01">
   <mass>10.0</mass>
   <orientation>0.77932 0.541882 0.311343 0.0457122</orientation>
   <position>0.147468 -0.14895 1.67565</position>
   <shape id="shape_Bip01_L_UpperArm01">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_L_UpperArm01_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_L_UpperArm01_geom">
     <capsule>
      <p0>0.0 0.0 0.095</p0>
      <p1>0.0 0.0 0.195</p1>
      <radius>0.095</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_L_Forearm01">
   <mass>10.0</mass>
   <orientation>-0.819525 -0.527274 -0.180703 -0.133072</orientation>
   <position>0.302287 -0.071897 1.4435</position>
   <shape id="shape_Bip01_L_Forearm01">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_L_Forearm01_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <position>0.0 0.0 0.0</position>
    <geometry id="Bip01_L_Forearm01_geom">
     <capsule>
      <p0>0.0 0.0 0.1</p0>
      <p1>0.0 0.0 0.3</p1>
      <radius>0.1</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_R_UpperArm01">
   <mass>10.0</mass>
   <orientation>-0.69305 -0.679101 0.110465 0.215175</orientation>
   <position>-0.220966 -0.099472 1.65846</position>
   <shape id="shape_Bip01_R_UpperArm01">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_R_UpperArm01_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_R_UpperArm01_geom">
     <capsule>
      <p0>0.0 0.0 0.095</p0>
      <p1>0.0 0.0 0.195</p1>
      <radius>0.095</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_R_Forearm01">
   <mass>10.0</mass>
   <orientation>-0.683462 -0.692661 0.159377 0.166432</orientation>
   <position>-0.349892 -0.0565646 1.40285</position>
   <shape id="shape_Bip01_R_Forearm01">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_R_Forearm01_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_R_Forearm01_geom">
     <capsule>
      <p0>0.0 0.0 0.1</p0>
      <p1>0.0 0.0 0.3</p1>
      <radius>0.1</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_Head01">
   <mass>20.0</mass>
   <orientation>-0.142286 -0.158925 -0.716185 0.664512</orientation>
   <position>-0.0353624 -0.159697 1.81746</position>
   <shape id="shape_Bip01_Head01">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_Head01_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <position>0.0 1.33514e-007 0.0669579</position>
    <geometry id="Bip01_Head01_geom">
     <sphere>
      <radius>0.13</radius>
     </sphere>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_Pelvis01">
   <mass>10.0</mass>
   <orientation>-0.0430834 -0.0677587 -0.641852 0.762613</orientation>
   <position>-0.0277656 -0.122027 1.04092</position>
   <shape id="shape_Bip01_Pelvis01">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_Pelvis01_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <position>0.0 0.0 0.0</position>
    <geometry id="Bip01_Pelvis01_geom">
     <sphere>
      <radius>0.0295858</radius>
     </sphere>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bone01">
   <mass>10.0</mass>
   <orientation>0.577094 -0.815036 0.00364817 0.051625</orientation>
   <position>0.799901 0.168317 0.763729</position>
   <shape id="shape_Bone01">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bone01_mat">
     <dynamicfriction>0.4</dynamicfriction>
     <restitution>0.25</restitution>
     <staticfriction>0.4</staticfriction>
    </physicsmaterial>
    <geometry id="Bone01_geom">
     <convex facecount="0">
      <vertices count="6">
         -0.912688 0.00935755 -0.00362035,
         1.05778 0.0378162 0.0686199,
         1.05447 -0.0618354 0.0687781,
         1.05358 0.0380692 -0.0907875,
         1.05028 -0.0615824 -0.0906294,
         1.24404 0.0175351 -0.00591039,
      </vertices>
     </convex>
    </geometry>
   </shape>
  </rigidbody>
  <joint child="#Bip01_R_Thigh01" class="novodex" id="Joint_Bip01_R_Thigh01" parent="#Bip01_Spine02">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.997494 -0.0409663 -0.0576847</x>
    <y>-0.039164 -0.998719 0.0320372</y>
    <z>-0.0589233 -0.0296977 -0.997821</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.0342869 -0.0949044 0.0925328</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>23.1632 68.9993 9.6348</rotlimitmax>
   <rotlimitmin>-23.1632 -68.9993 -24.6682</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_R_Calf01" class="novodex" id="Joint_Bip01_R_Calf01" parent="#Bip01_R_Thigh01">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.997402 0.0 -0.0720415</x>
    <y>-0.0720415 -2.26153e-007 -0.997402</y>
    <z>0.0 1.0 -2.24196e-007</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.0 -2.25886e-007 0.598059</offset>
    <x>1.0 5.33267e-007 0.0</x>
    <y>0.0 3.20313e-007 -1.0</y>
    <z>-5.33267e-007 1.0 3.20313e-007</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 0.0</rotlimitmax>
   <rotlimitmin>0.0 0.0 -120.0</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_L_Thigh01" class="novodex" id="Joint_Bip01_L_Thigh01" parent="#Bip01_Spine02">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.974584 0.223887 0.0078179</x>
    <y>0.220481 -0.96477 0.143551</y>
    <z>0.0396817 -0.138179 -0.989612</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.0120826 0.155697 0.0857522</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>51.1545 63.6791 1.4856</rotlimitmax>
   <rotlimitmin>-51.1545 -63.6791 -36.3315</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_L_Calf01" class="novodex" id="Joint_Bip01_L_Calf01" parent="#Bip01_L_Thigh01">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.971608 0.0 -0.236595</x>
    <y>-0.236595 -1.81123e-007 -0.971608</y>
    <z>0.0 1.0 -1.61103e-007</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.0 0.0 0.598059</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 0.0 -1.0</y>
    <z>0.0 1.0 0.0</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 0.0</rotlimitmax>
   <rotlimitmin>0.0 0.0 -120.0</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_L_UpperArm01" class="novodex" id="Joint_Bip01_L_UpperArm01" parent="#Bip01_Spine02">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>-0.927945 0.293219 -0.230088</x>
    <y>0.138803 0.844788 0.516786</y>
    <z>0.345907 0.447612 -0.824616</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>-0.0485323 0.17681 0.570407</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>62.0812 31.1647 22.6199</rotlimitmax>
   <rotlimitmin>-62.0812 -31.1647 -15.9454</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_L_Forearm01" class="novodex" id="Joint_Bip01_L_Forearm01" parent="#Bip01_L_UpperArm01">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.947286 0.00424977 -0.32036</x>
    <y>-0.320369 0.00168975 -0.947292</y>
    <z>-0.00348443 0.99999 0.00296217</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.0 0.0 0.289483</offset>
    <x>0.999991 0.00424959 0.0</x>
    <y>-7.17947e-006 0.00168943 -0.999999</y>
    <z>-0.00424958 0.99999 0.00168945</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 0.0</rotlimitmax>
   <rotlimitmin>0.0 0.0 -70.0</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_R_UpperArm01" class="novodex" id="Joint_Bip01_R_UpperArm01" parent="#Bip01_Spine02">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>-0.998666 -0.0476157 -0.0199551</x>
    <y>-0.03361 0.893003 -0.448795</y>
    <z>0.0391897 -0.447526 -0.893412</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>-0.0638624 -0.194357 0.548342</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>67.9139 16.4223 44.9685</rotlimitmax>
   <rotlimitmin>-67.9139 -16.4223 -29.9722</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_R_Forearm01" class="novodex" id="Joint_Bip01_R_Forearm01" parent="#Bip01_R_UpperArm01">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.989925 0.0 -0.141596</x>
    <y>-0.141596 0.0 -0.989925</y>
    <z>0.0 1.0 0.0</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.0 0.0 0.289483</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 2.9342e-007 -1.0</y>
    <z>0.0 1.0 2.9342e-007</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 0.0</rotlimitmax>
   <rotlimitmin>0.0 0.0 -110.0</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_Head01" class="novodex" id="Joint_Bip01_Head01" parent="#Bip01_Spine02">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.863751 -0.0246841 -0.503314</x>
    <y>-0.00135772 0.998682 -0.0513086</y>
    <z>0.503917 0.0450013 0.862579</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>-0.0361825 -0.0056372 0.712582</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>13.2734 11.3099 10.3048</rotlimitmax>
   <rotlimitmin>-13.2734 -11.3099 -10.6197</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_Pelvis01" class="novodex" id="Joint_Bip01_Pelvis01" parent="#Bip01_Spine02">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.934207 -0.258466 -0.245873</x>
    <y>0.248933 0.966013 -0.0696551</y>
    <z>0.25552 0.00386637 0.966796</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.00346158 0.00544413 -0.0638186</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 0.0</rotlimitmax>
   <rotlimitmin>0.0 0.0 0.0</rotlimitmin>
   <Spring>0</Spring>
  </joint>
 </physicsmodel>
</library>
