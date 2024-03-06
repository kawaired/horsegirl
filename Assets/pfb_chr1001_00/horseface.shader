Shader "Unlit/horseface"
{
    Properties
    {
        _GlobalVertexDepthLinear("globalvertexdepthlinear",range(0,0.1))=0.05
        _GlobalFarClipLog("globalfarcliplog",range(0.1,10))=0.5
        _Global_FogMinDistance("global_fogmindistance",float)=(0.1,0.1,0.1,0.1)
        _Global_FogLenghth("global_fogdistance",float)=(0.1,0.1,0.1,0.1)
        _Global_MaxDensity("global_maxdensity",float)=0.1
        _Global_MaxHeight("global_maxheigh",float)=0.1
        _SpecularPower("specularpower",range(0,1))=3
        _CylinderBlend("cylinderblend",range(0,1))=1
        _FaceUp("faceup",float)=(0.2,0.2,0.2)
        _FaceCenterPos("facecenterpos",float)=(0.2,0.2,0.2)
        _FaceForward("faceforward",float)=(0,0,1)


        _Global_FogColor("global_fogcolor",Color)=(0.5,0.5,0.5,0.5)
        _UseOptionMaskMap("useoptionmaskmap",range(0,1))=1
        _SpecularColor("specularcolor",color)=(0.2,0.2,0.2,0.2)
        _EnvRate("envrate",float)=0.2
        _EnvBias("envbias",float)=0.2
        _ToonStep("toonstep",float)=0.2
        _ToonFeather("toonfeather",range(-1,5))=0.2
        _ToonBrightColor("toonbrightcolor",color)=(0.6,0.6,0.6,0.6)
        _ToonDarkColor("toondarkcolor",color)=(0.2,0.2,0.2,0.2)
        _RimStep("rimstep",float)=0.2
        _RimFeather("rimfeather",float)=0.3
        _RimColor("rimcolor",color)=(0.4,0.4,0.4,0.4)
        _RimShadow("rimshadow",float)=0.3
        _RimSpecRate("rimspecrate",float)=0.2
        _RimShadowRate("rimshadowrate",float)=0.3
        _RimHorizonOffset("rimhorizonoffset",range(-1,1))=0.2
        _RimVerticalOffset("rimverticaloffset",range(-1,1))=0.4
        _RimStep2("rimstep2",float)=0.4
        _RimFeather2("rimfeather2",float)=0.4
        _RimColor2("rimcolor2",color)=(0,0,0,0)
        _RimSpecRate2("rimspecrate2",float)=0.2
        _RimHorizonOffset2("rimhorizonoffset2",float)=0.1
        _RimVerticalOffset2("rimverticaloffset2",float)=0.2
        _RimShadowRate2("rimshadowrate2",float)=0.3
        _CharaColor("characolor",color)=(0.5,0.5,0.5,0.5)
        _Saturation("saturation",float)=0.4
        _DirtRate("dirtrate",float)=(0.3,0.3,0.3)
        _GlobalDirtColor("globaldirtcolor",color)=(0.2,0.2,0.2,0.2)
        _GlobalDirtRimSpecularColor("globaldirtrimspecularcolor",color)=(0.2,0.2,0.2,0.2)
        _GlobalDirtToonColor("globaldirttooncolor",color)=(0.1,0.1,0.1,0.1)
        _DirtScale("dirtrate",float)=0.2
        _GlobalToonColor("globaltooncolor",color)=(0.2,0.2,0.2,0.2)
        _GlobalRimColor("globalrimcolor",color)=(0.1,0.1,0.1,0.1)
        _LightProbeColor("lightprobecolor",color)=(0,0,0,0)
        _EmissiveColor("emissivecolor",color)=(0.1,0.1,0.1,0.1)
        _CheekPretenseThreshold("cheekpretensethreshold",float)=0.1
        _NosePretenseThreshold("nosepretensethreshold",float)=0.2
        _NoseVisibility("nosevisibility",float)=0.2
        _UseOriginalDirectionalLight("useorigionaldirectionallight",range(0,2))=2
        _OriginalDirectionalLightDir("originaldirectionallightdir",float)=(0.2,0.2,0.2)
        _VertexColorToonPower("vertexcolortoonpower",range(0,1))=0.2
        _FaceShadowAlpha("faceshadowalpha",float)=0.2
        _FaceShadowEndY("faceshadowendy",float)=0.4
        _FaceShadowLength("faceshadowlength",float)=0.3
        _FaceShadowColor("faceshadowcolor",color)=(0.2,0.2,0.2,0.2)

        _MainTex ("maintex", 2D) = "white" {}
        _TripleMaskMap("triplemaskmap",2D)="white"{}
        _OptionMaskMap("optionmaskmap",2D)="white"{}
        _ToonMap("toonmap",2D)="white"{}
        _DirtTex("dirttex",2D)="white"{}
        _EnvMap("envmap",2D)="white"{}
        _EmissionTex("emissiontex",2D)="white"{}

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            //cull off
            // Tags{"LightMode"="ForwardBase"}
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float2 uv2:TEXCOORD1;
                float4 color:COLOR;
                float3 normal:NORMAL;
                
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float4 v1:TEXCOORD1;
                float3 worldvertexlerpnormal:TEXCOORD2;
                float3 worldvertex:TEXCOORD3;
                float3 viewvertexlerpnormal:TEXCOORD4;
                float v6:TEXCOORD5;
                float4 color:COLOR;
                float4 test:TEXCOORD6;
                float2 uv2:TEXCOORD7;
               
            };

            float4 _LightColor0;

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _EnvMap;
            float4 _EnvMap_ST;
            sampler2D _OptionMaskMap;
            float4 _OptionMaskMap_ST;
            sampler2D _ToonMap;
            float4 _ToonMap_ST;
            sampler2D _TripleMaskMap;
            float4 _TripleMaskMap_ST;
            sampler2D _DirtTex;
            float4 _DirtTex_ST;
            sampler2D _EmissionTex;
            float4 _EmissionTex_ST;


            float _GlobalFarClipLog;
            float _GlobalVertexDepthLinear;
            float4 _Global_FogMinDistance;
            float4 _Global_FogLenghth;
            float _Global_MaxHeight;
            float _Global_MaxDensity;
            float _CylinderBlend;
            float3 _FaceCenterPos;
            float3 _FaceForward;
            float3 _FaceUp;
            float _SpecularPower;
            float _RimHorizonOffset;
            float _RimVerticalOffset;
            float _UseOptionMaskMap;
            float4 _SpecularColor;
            float4 _GlobalToonColor;
            float4 _ToonDarkColor;
            float4 _ToonBrightColor;
            float _VertexColorToonPower;
            float _UseOriginalDirectionalLight;
            float3 _OriginalDirectionalLightDir;
            float _ToonStep;
            float _ToonFeather;
            float4 _GlobalDirtToonColor;
            float4 _GlobalDirtColor;
            float _DirtScale;
            float3 _DirtRate;
            float _EnvBias;
            float _EnvRate;
            float _RimStep;
            float _RimFeather;
            float4 _RimColor;
            float _RimSpecRate;
            float _RimShadow;
            float _RimShadowRate;
            float4 _GlobalRimColor;
            float _RimHorizonOffset2;
            float _RimVerticalOffset2;
            float _RimShadowRate2;
            float _RimStep2;
            float _RimFeather2;
            float4 _RimColor2;
            float _RimSpecRate2;
            float4 _GlobalDirtRimSpecularColor;
            float _CheekPretenseThreshold;
            float _NosePretenseThreshold;
            float4 _EmissiveColor;
            float4 _CharaColor;
            float _FaceShadowEndY;
            float _FaceShadowLength;
            float4 _FaceShadowColor;
            float _FaceShadowAlpha;
            float4 _Global_FogColor;
            float _NoseVisibility;
            float _Saturation;
            float4 _LightProbeColor;

            v2f vert (appdata v)
            {
                v2f o;
                //对模型在裁切空间进行深度偏移
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.test=o.vertex;
                //o.worldvertex=UnityObjectToWorldDir(normalize(v.vertex.xyz));
                o.worldvertex=mul(float4x4(unity_ObjectToWorld),v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                float xlat12=0;
                xlat12 = o.vertex.w*0.005+1;
                xlat12=log2(xlat12)*0.7;
                xlat12=xlat12/_GlobalFarClipLog;
                xlat12=xlat12*2-1;
                xlat12=xlat12*o.vertex.w-o.vertex.z;
                o.vertex.z=_GlobalVertexDepthLinear*xlat12+o.vertex.z;

                //用模型的观察者空间的z值进行值的输出
                float3 viewvertex=UnityWorldToViewPos(o.worldvertex);
                xlat12=-viewvertex.z-_Global_FogMinDistance.w;
                xlat12=xlat12/_Global_FogLenghth.w;
                xlat12=1-saturate(xlat12);
                float4 xlat1=float4(0,0,0,0);
                xlat1.x=saturate(o.worldvertex.y/_Global_MaxHeight);
                xlat1.x=1-xlat1.x;
                o.v6=xlat12*xlat1.x+_Global_MaxDensity;
                o.v6=saturate(o.v6);
                o.uv2=v.uv2;

                //输入模型本身的颜色
                o.color=v.color;

                float xlat16=1-_CylinderBlend;
                xlat12=xlat16;
                float3 worldnormal=UnityObjectToWorldNormal(v.normal);
                float3 xlat3=o.worldvertex-_FaceCenterPos;
                float xlat13=dot(xlat3,_FaceUp);
                xlat3=xlat13*_FaceUp+_FaceCenterPos;
                xlat3=o.worldvertex-xlat3;//计算出面部定点相对中心位置的横向坐标。
                xlat3=normalize(xlat3);
                // xlat1.xyz=worldnormal-xlat3;//计算出相对横向方向到法线的方向
                // xlat1.xyz=xlat12*xlat1+xlat3;//对二者进行插值的中间向量
                // o.worldvertexlerpnormal=xlat1.xyz;
                o.worldvertexlerpnormal=lerp(xlat3,worldnormal,xlat12);
                //o.worldvertexlerpnormal=lerp(worldnormal,xlat3,_CylinderBlend);
                //o.worldvertexlerpnormal=xlat3;
                o.viewvertexlerpnormal=UnityWorldToViewPos(o.worldvertexlerpnormal.xyz);//o.v2的观察者空间
                float4x4 faceshadowheadmat=float4x4(1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1);
                o.v1=mul(faceshadowheadmat,float4(o.worldvertex.xyz,1));
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
            //     return i.viewvertexlerpnormal.xyzz;
            // return float4(i.worldvertexlerpnormal.xy,0,0);
            float tex5=0;
            float3 tex1=float3(0,0,0);
            float3 tex2=float3(0,0,0);
            float3 tex3=float3(0,0,0);
            float4 tex9=float4(0,0,0,0);

            float3 xlat0=float3(0,0,0);
            float3 lightdir=float3(0,0,0);

            tex9=i.v1;
            tex5=i.v6;
            xlat0.xy=(i.viewvertexlerpnormal.xy+float2(1,1))*0.5;

            //贴图采样
            float4 envtex=tex2D(_EnvMap,xlat0.xy);//环境光贴图的采样
            //return envtex;
            float4 optionmaskmap=tex2D(_OptionMaskMap,i.uv);
            float4 maintex=tex2D(_MainTex,i.uv);
            float4 toonmap=tex2D(_ToonMap,i.uv);
            float4 triplemaskmap=tex2D(_TripleMaskMap,i.uv);
            float4 dirttex=tex2D(_DirtTex,i.uv);
            float4 emissiontex=tex2D(_EmissionTex,i.uv);
            
           
            //高光反射
            float specularpower=max(_SpecularPower*10+1,0);
            float3 viewdir=normalize(_WorldSpaceCameraPos.xyz-i.worldvertex.xyz);
            float3 camxdir=float3(UNITY_MATRIX_V[0].x,UNITY_MATRIX_V[1].x,UNITY_MATRIX_V[2].x);
            float3 camydir=float3(UNITY_MATRIX_V[0].y,UNITY_MATRIX_V[1].y,UNITY_MATRIX_V[2].y);
            float3 viewoffset=float3(0,0,0);
            viewoffset=lerp(viewdir,camxdir*((_RimHorizonOffset<=0)-(_RimHorizonOffset>0)),abs(_RimHorizonOffset));
            viewoffset=lerp(viewoffset,camydir*((_RimVerticalOffset<=0)-(_RimVerticalOffset>0)),abs(_RimVerticalOffset));
            float specularfactor=dot(viewoffset,i.worldvertexlerpnormal);
            specularfactor=min(pow(max(specularfactor,0.01),specularpower),1);
            //float4 optionmaskmap=tex2D(_OptionMaskMap,i.uv);
            optionmaskmap.xyz=lerp(float3(0,0,0.5),optionmaskmap.xyz,_UseOptionMaskMap);
            specularfactor=specularfactor*optionmaskmap.x;
            float4 finalspecular=float4(0,0,0,1);
            finalspecular.xyz=max(_LightColor0.xyz*_SpecularColor.xyz*specularfactor,float3(0,0,0));
            //return finalspecular;



            // xlat4.xyz=lerp(xlat2,xlat3*xlat16_17,abs(_RimHorizonOffset));
            // xlat5=float3(UNITY_MATRIX_V[0].y,UNITY_MATRIX_V[1].y,UNITY_MATRIX_V[2].y);
            // xlat16_17.xyz=lerp(xlat4,xlat5.xyz*xlat16_17.y,abs(_RimVerticalOffset));
            // xlat48=dot(xlat16_17,i.worldvertexlerpnormal);
            // xlat16_1.x=min(pow(max(xlat48,0.01),xlat16_1.x),1);//这里的xlat16_1∈(0,1);
            // xlat16_4.xyz=tex2D(_OptionMaskMap,i.uv).xyz;
            // xlat4.xyz=lerp(float3(0,0,0.5),xlat16_4.xyz,_UseOptionMaskMap);
            // xlat16_1.x=xlat16_1.x*xlat4.x;
            // xlat16_17.xyz=_LightColor0.xyz*_SpecularColor.xyz;
            // xlat16_1.xyz=max(xlat16_1.x*xlat16_17.xyz,float3(0,0,0));//混出来得高光颜色
            
            //漫反射
            float  difffactor=(1-i.color.w)*_VertexColorToonPower;
            lightdir=lerp(normalize(-_WorldSpaceLightPos0.xyz),normalize(_OriginalDirectionalLightDir.xyz),_UseOriginalDirectionalLight>=1);
            //return lightdir.xyzz;
            float lambert=dot(i.worldvertexlerpnormal,lightdir.xyz);
            float halflambert=lambert*0.5+0.5;
            lambert=max(lambert,0);
            difffactor=1-2*difffactor*(min(halflambert-0.5,0)+0.5);
            float4 toontone=float4(0,0,0,1);
            toontone.xyz=toonmap.xyz*_LightColor0.xyz*_GlobalToonColor.xyz;
            float4 toondark=float4(0,0,0,1);
            toondark.xyz=toontone.xyz*lerp(float3(1,1,1),_ToonDarkColor.xyz,difffactor*(_ToonDarkColor.w<=0.5))+difffactor*_ToonDarkColor.xyz*(_ToonDarkColor.w>0.5);

            float4 maintone=float4(0,0,0,1);
            maintone.xyz=maintex.xyz*_LightColor0.xyz;
            float4 toonbright=float4(0,0,0,1);
            toonbright.xyz=maintone*lerp(float3(1,1,1),_ToonBrightColor.xyz,difffactor*(_ToonBrightColor.w<=0.5))+difffactor*_ToonBrightColor.xyz*(_ToonBrightColor.w>0.5);
     
            float tripone=-triplemaskmap.x*halflambert+_ToonStep-_ToonFeather;
            float triptwo=-triplemaskmap.x*halflambert+_ToonStep;
            tripone=saturate((tripone/_ToonFeather)+1)*(0<_ToonFeather);
            triptwo=saturate((triptwo-0.05)*20+1);
            float4 finaldiffuse=float4(0,0,0,1);
            finaldiffuse.xyz=lerp(toonbright,toondark,tripone);
            //return tripone;
            //return finaldiffuse;
            float4 currentcolor=float4(0,0,0,1);
            currentcolor.xyz=finaldiffuse.xyz+finalspecular.xyz;
            //return finalspecular;
            return currentcolor;


            float4 globalcolor=float4(0,0,0,1);
            globalcolor.xyz=lerp(_GlobalDirtColor.xyz,_GlobalDirtToonColor.xyz,tripone);
            float dirtlerpfactor=dot(dirttex*_DirtScale,_DirtRate);
            //return dirtlerpfactor;
            currentcolor.xyz=lerp(globalcolor.xyz,currentcolor.xyz,dirtlerpfactor);
            //return currentcolor;
            float4 envcolor=float4(0,0,0,1);
            envcolor.xyz=currentcolor.xyz*envtex.xyz;
            //return envtex;
            envcolor.xyz=lerp(envcolor.xyz*_EnvBias,currentcolor.xyz,optionmaskmap.y*_EnvRate);
            return optionmaskmap.yyyy;
            //return currentcolor;
            return envcolor;
            float rimfactor=_RimStep-_RimFeather-specularfactor;
            rimfactor=saturate(1+(rimfactor/_RimFeather));
            rimfactor=pow(rimfactor,3)*_RimColor.w*optionmaskmap.z;
            float4 rimcolor=float4(0,0,0,1);
            rimcolor.xyz=lerp(_SpecularColor.xyz,_RimColor.xyz,_RimSpecRate);
            rimcolor.xyz=rimcolor.xyz*rimfactor;
            //return rimcolor;
            float lamb2=lambert+_RimShadowRate2;
            lambert=lambert+_RimShadow+_RimShadowRate;
            envcolor.xyz=rimcolor.xyz*lambert*_GlobalRimColor.xyz+envcolor.xyz;
            // envcolor;
            
            float3 viewoffset2=lerp(viewdir,camxdir*((_RimHorizonOffset2<=0)-(_RimHorizonOffset2>0)),abs(_RimHorizonOffset2));
            viewoffset2=lerp(viewoffset2,camydir*((_RimVerticalOffset2<=0)-(_RimVerticalOffset2>0)),abs(_RimVerticalOffset2));
            float specularfactor2=dot(viewoffset2,i.worldvertexlerpnormal);
            specularfactor2=_RimStep2-_RimFeather2+specularfactor2;
            specularfactor2=saturate(1+(specularfactor2/_RimFeather2));
            specularfactor2=pow(specularfactor2,3)*_RimColor.w*optionmaskmap.z;
            float4 specularcolor2=float4(0,0,0,1);
            specularcolor2.xyz=lerp(_SpecularColor.xyz,_RimColor2.xyz,_RimSpecRate2)*specularfactor2*lamb2;
            envcolor.xyz=specularcolor2.xyz*_GlobalRimColor.xyz+envcolor.xyz;
            float globalfactor=dot(optionmaskmap.xy,_GlobalRimColor.xy)+optionmaskmap.w*_GlobalRimColor.z;
            float4 globalcolor2=float4(0,0,0,1);
            globalcolor2.xyz=(0.00001>=globalfactor)*_GlobalDirtColor.xyz+(0.00001<globalfactor)*_GlobalDirtRimSpecularColor.xyz;
            envcolor=lerp(envcolor,globalcolor2,dirtlerpfactor);
            float complementationdirt=1-dirtlerpfactor;
            float3 lightforwardthreshold=cross(lightdir.xyz,_FaceForward.xyz);
            float faceupfactor=dot(lightforwardthreshold,_FaceUp);
            faceupfactor=(faceupfactor>=0)-(faceupfactor<0);
            float3 relativevertx=i.worldvertex.xyz-_FaceCenterPos.xyz;
            float relativefactor=dot(cross(relativevertx,_FaceForward),_FaceUp);
            relativefactor=(relativefactor>=0)-(relativefactor<0);
            float diffusefactor2=(faceupfactor*relativefactor+1)*0.5;
            float4 diffuse2=lerp(_ToonDarkColor,_ToonBrightColor,diffusefactor2);
            float4 diffuse3=lerp(_ToonBrightColor,_ToonDarkColor,diffusefactor2);
            //diffuse2.xyz=diffuse2.xyz-envcolor.xyz;
            float lightfactor=max(1-2*abs(0.5-max(dot(_FaceForward,-lightdir)+0.1,0)),0);
            float lightupfactor=min(dot(_FaceUp.xyz,lightdir.xyz),0)+1;
            float lightforwardfactor=saturate(2*(1-abs(dot(_FaceForward.xyz,lightdir.xyz))));
            float singelfactor=0;
            float2 doublefactor=float2(0,0);
            singelfactor=2*pow(lightfactor,2)*lightfactor*max(triplemaskmap.y-0.51,0)*triptwo;
            doublefactor=float2(1-_CheekPretenseThreshold,1-_NosePretenseThreshold);
            envcolor.xyz=lerp(envcolor.xyz,diffuse2.xyz,(singelfactor>doublefactor.x)*(triplemaskmap.y>=0.51));
            singelfactor=(1-2*min(triplemaskmap.y,0.49))*lightforwardfactor;
            envcolor.xyz=lerp(envcolor.xyz,diffuse3.xyz,(singelfactor>=doublefactor.y)*(0.49>=triplemaskmap.y)*_NoseVisibility); 
            float4 emissivecolor=float4(0,0,0,1);
            emissivecolor.xyz=emissivecolor.xyz*emissiontex.xyz*complementationdirt;
            float4 indirectcolor=float4(0,0,0,1);
            indirectcolor.xyz=_CharaColor.xyz*_LightProbeColor.xyz;
            envcolor.xyz=envcolor.xyz*indirectcolor.xyz+emissivecolor.xyz;
            singelfactor=saturate((tex9.y-_FaceShadowEndY)/_FaceShadowLength);
            singelfactor=singelfactor*_FaceShadowAlpha*triplemaskmap.z;
            float4 faceshadow=float4(0,0,0,1);
            faceshadow.xyz=envcolor.xyz*singelfactor*_FaceShadowAlpha*triplemaskmap.z;
            float4 faceshadow2=float4(0,0,0,1);
            faceshadow2.xyz=envcolor.xyz*(1-singelfactor*_FaceShadowAlpha)*triplemaskmap.z;
            envcolor.xyz=lerp(_Global_FogColor,(1-triplemaskmap.z)*envcolor.xyz+faceshadow2.xyz+faceshadow.xyz*_FaceShadowColor.xyz,tex5);
            float4 finalcolor=float4(0,0,0,maintex.w);
            finalcolor.xyz=(dot(envcolor.xyz,float3(0.2125,0.7154,0.0721))*(1-_Saturation)).xxx+envcolor.xyz*_Saturation;
            return finalcolor;
            }
            ENDCG
        }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv2:TEXCOORD1;
            };

            struct v2f
            {
                float2 uv2:TEXCOORD1;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv2 = TRANSFORM_TEX(v.uv2, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                if(i.uv2.x==0 && i.uv2.y==0)
                {
                    discard;
                }
               return float4(0,0,0,0);
            }
            ENDCG
        }
    }
}
