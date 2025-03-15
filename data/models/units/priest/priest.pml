<?xml version="1.0"?>
<library id="HighPriest_Rerooted_PhysX" type="physics">
 <scenedesc source="3dsmax">
  <eye>-0.167544 -3.46746 0.441901</eye>
  <gravity>0.0 0.0 -10.0</gravity>
  <lookat>-0.271819 -2.47536 0.372141</lookat>
  <up>0.0 0.0 1.0</up>
 </scenedesc>
 <physicsmodel id="main">
  <rigidbody id="Bip01_Spine">
   <mass>40.0</mass>
   <orientation>0.0339512 0.0370395 -0.736238 0.674855</orientation>
   <position>-0.0328886 -0.12453 1.10481</position>
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
      <p0>0.0 0.0 0.21</p0>
      <p1>0.0 0.0 0.4331</p1>
      <radius>0.21</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_R_Thigh">
   <mass>20.0</mass>
   <orientation>-0.659486 0.751165 0.0118694 0.0262168</orientation>
   <position>-0.130412 -0.159603 1.19428</position>
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
      <p1>0.0 0.0 0.47</p1>
      <radius>0.13</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_R_Calf">
   <mass>10.0</mass>
   <orientation>0.657779 -0.748508 -0.0488878 -0.0683617</orientation>
   <position>-0.116219 -0.128258 0.597207</position>
   <shape id="shape_Bip01_R_Calf">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_R_Calf_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_R_Calf_geom">
     <capsule>
      <p0>0.0 0.0 0.12</p0>
      <p1>0.0 0.0 0.51</p1>
      <radius>0.12</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_L_Thigh">
   <mass>20.0</mass>
   <orientation>-0.746963 0.660168 -0.0662794 0.0428047</orientation>
   <position>0.121171 -0.158565 1.18756</position>
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
      <p1>0.0 0.0 0.47</p1>
      <radius>0.13</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_L_Calf">
   <mass>10.0</mass>
   <orientation>-0.74876 0.647248 0.0412952 0.136836</orientation>
   <position>0.214189 -0.172658 0.596952</position>
   <shape id="shape_Bip01_L_Calf">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_L_Calf_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_L_Calf_geom">
     <capsule>
      <p0>0.0 0.0 0.12</p0>
      <p1>0.0 0.0 0.51</p1>
      <radius>0.12</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_L_UpperArm">
   <mass>10.0</mass>
   <orientation>0.769449 0.543025 0.334998 0.0291426</orientation>
   <position>0.147468 -0.14895 1.67565</position>
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
      <p1>0.0 0.0 0.195</p1>
      <radius>0.095</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_L_Forearm">
   <mass>10.0</mass>
   <orientation>-0.818498 -0.528012 -0.185298 -0.130112</orientation>
   <position>0.305866 -0.0566116 1.45163</position>
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
      <p0>0.0 0.0 0.1</p0>
      <p1>0.0 0.0 0.3</p1>
      <radius>0.1</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_R_UpperArm">
   <mass>10.0</mass>
   <orientation>-0.698664 -0.672947 0.109497 0.216843</orientation>
   <position>-0.220966 -0.099472 1.65846</position>
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
      <p1>0.0 0.0 0.195</p1>
      <radius>0.095</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_R_Forearm">
   <mass>10.0</mass>
   <orientation>-0.688793 -0.686996 0.160267 0.16708</orientation>
   <position>-0.349742 -0.05442 1.40315</position>
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
      <p1>0.0 0.0 0.3</p1>
      <radius>0.1</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_Head">
   <mass>20.0</mass>
   <orientation>-0.131587 -0.167891 -0.758113 0.616248</orientation>
   <position>-0.0353624 -0.159697 1.81746</position>
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
      <radius>0.13</radius>
     </sphere>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_Pelvis">
   <mass>10.0</mass>
   <orientation>-0.0430834 -0.0677587 -0.641852 0.762613</orientation>
   <position>-0.0277656 -0.122027 1.04092</position>
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
  <rigidbody id="bone_staff">
   <mass>10.0</mass>
   <orientation>0.477045 -0.565051 0.488116 0.463561</orientation>
   <position>-0.276953 -0.313759 -0.0932991</position>
   <shape id="shape_bone_staff">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <geometry id="bone_staff_geom">
     <convex facecount="0">
      <vertices count="6">
         0.182707 0.0 0.0,
         2.04121 0.019896 0.0390723,
         2.04121 -0.0198964 0.0390723,
         2.04121 0.0198959 -0.0245344,
         2.04121 -0.0198965 -0.0245344,
         2.31124 -3.02435e-007 -3.52832e-007,
      </vertices>
     </convex>
    </geometry>
   </shape>
  </rigidbody>
  <joint child="#Bip01_R_Thigh" class="novodex" id="Joint_Bip01_R_Thigh" parent="#Bip01_Spine">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.99811 -0.0409663 0.0458091</x>
    <y>-0.0422679 -0.998719 0.027814</y>
    <z>0.044611 -0.0296977 -0.998563</z>
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
  <joint child="#Bip01_R_Calf" class="novodex" id="Joint_Bip01_R_Calf" parent="#Bip01_R_Thigh">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.993692 0.0 -0.112144</x>
    <y>-0.112144 -2.21526e-007 -0.993692</y>
    <z>0.0 1.0 -2.18132e-007</z>
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
  <joint child="#Bip01_L_Thigh" class="novodex" id="Joint_Bip01_L_Thigh" parent="#Bip01_Spine">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.968547 0.223887 0.10859</x>
    <y>0.204449 -0.96477 0.165588</y>
    <z>0.141838 -0.138179 -0.980198</z>
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
  <joint child="#Bip01_L_Calf" class="novodex" id="Joint_Bip01_L_Calf" parent="#Bip01_L_Thigh">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.959043 0.0 -0.28326</x>
    <y>-0.28326 -1.7958e-007 -0.959043</y>
    <z>0.0 1.0 -1.54327e-007</z>
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
  <joint child="#Bip01_L_UpperArm" class="novodex" id="Joint_Bip01_L_UpperArm" parent="#Bip01_Spine">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>-0.912168 0.293219 -0.286309</x>
    <y>0.106995 0.844788 0.524295</y>
    <z>0.395603 0.447612 -0.801961</z>
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
  <joint child="#Bip01_L_Forearm" class="novodex" id="Joint_Bip01_L_Forearm" parent="#Bip01_L_UpperArm">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.93014 0.00424977 -0.36718</x>
    <y>-0.367189 0.00168975 -0.930145</y>
    <z>-0.00333245 0.99999 0.00313217</z>
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
  <joint child="#Bip01_R_UpperArm" class="novodex" id="Joint_Bip01_R_UpperArm" parent="#Bip01_Spine">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>-0.999103 -0.0322603 -0.0274446</x>
    <y>-0.0165159 0.893415 -0.448929</y>
    <z>0.039002 -0.448073 -0.893146</z>
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
  <joint child="#Bip01_R_Forearm" class="novodex" id="Joint_Bip01_R_Forearm" parent="#Bip01_R_UpperArm">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.989317 0.0 -0.145782</x>
    <y>-0.145782 0.0 -0.989317</y>
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
  <joint child="#Bip01_Head" class="novodex" id="Joint_Bip01_Head" parent="#Bip01_Spine">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.859584 0.0882692 -0.503314</x>
    <y>-0.1317 0.989961 -0.0513086</y>
    <z>0.493732 0.110391 0.862579</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>-0.0361825 -0.0056372 0.712582</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>13.2734 44.9509 60.1279</rotlimitmax>
   <rotlimitmin>-13.2734 -44.9509 -58.2167</rotlimitmin>
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
