Shader "Unlit/body"
{
    Properties
    {
        _GlobalVertexDepthLinear("globalvertexdepthlinear",range(0,0.1))=0.05
        _GlobalFarClipLog("globalfarcliplog",range(0.1,10))=0.5
        _Global_FogMinDistance("global_fogmindistance",float)=(0.1,0.1,0.1,0.1)
        _Global_FogLenghth("global_foglength",float)=(0.1,0.1,0.1,0.1)
        _Global_MaxDensity("global_maxdensity",float)=0.1
        _Global_MaxHeight("global_maxheigh",float)=0.1
        _SpecularPower("specularpower",range(0,1))=3
        _CylinderBlend("cylinderblend",range(0,1))=1
        _FaceUp("faceup",float)=(0.2,0.2,0.2)
        _FaceCenterPos("facecenterpos",float)=(0.2,0.2,0.2)
        _FaceForward("faceforward",float)=(0,0,1)
        _HightLightParam("hightlightparam",float)=(0.5,0.5,0.5,0.5)
        _HightLightColor("hightlightcolor",color)=(0.5,0.5,0.5,0.5)


        _Global_FogColor("global_fogcolor",Color)=(0.5,0.5,0.5,0.5)
        _UseOptionMaskMap("useoptionmaskmap",range(0,1))=1
        _SpecularColor("specularcolor",color)=(0.2,0.2,0.2,0.2)
        _EnvRate("envrate",range(0,1))=0.2
        _EnvBias("envbias",range(0,1))=0.2
        _ToonStep("toonstep",range(-1,5))=0.2
        _ToonFeather("toonfeather",range(-1,5))=0.2
        _ToonBrightColor("toonbrightcolor",color)=(0.6,0.6,0.6,0.6)
        _ToonDarkColor("toondarkcolor",color)=(0.2,0.2,0.2,0.2)
        _RimStep("rimstep",range(0,1))=0.2
        _RimFeather("rimfeather",range(0.01,1))=0.3
        _RimColor("rimcolor",color)=(0.4,0.4,0.4,0.4)
        _RimShadow("rimshadow",float)=0.3
        _RimSpecRate("rimspecrate",range(0,1))=0.2
        _RimShadowRate("rimshadowrate",float)=0.3
        _RimHorizonOffset("rimhorizonoffset",range(-1,1))=0.2
        _RimVerticalOffset("rimverticaloffset",range(-1,1))=0.4
        _RimStep2("rimstep2",range(0,1))=0.4
        _RimFeather2("rimfeather2",range(0.01,1))=0.4
        _RimColor2("rimcolor2",color)=(0,0,0,0)
        _RimSpecRate2("rimspecrate2",range(0,1))=0.2
        _RimHorizonOffset2("rimhorizonoffset2",range(0,1))=0.1
        _RimVerticalOffset2("rimverticaloffset2",range(0,1))=0.2
        _RimShadowRate2("rimshadowrate2",float)=0.3
        _CharaColor("characolor",color)=(0.5,0.5,0.5,0.5)
        _Saturation("saturation",range(-1,2))=0.4
        _DirtRate("dirtrate",float)=(0.3,0.3,0.3)
        _GlobalDirtColor("globaldirtcolor",color)=(0.2,0.2,0.2,0.2)
        _GlobalDirtRimSpecularColor("globaldirtrimspecularcolor",color)=(0.2,0.2,0.2,0.2)
        _GlobalDirtToonColor("globaldirttooncolor",color)=(0.1,0.1,0.1,0.1)
        _DirtScale("dirtscale",range(0,2))=0.2
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
        _CutOff("cutoff",range(0,1))=0.4
        _EmissionColor("emissioncolor",Color)=(0.2,0.2,0.2,0.2)

        _MainTex ("maintex", 2D) = "Black" {}
        _TripleMaskMap("triplemaskmap",2D)="White"{}
        _OptionMaskMap("optionmaskmap",2D)="Black"{}
        _ToonMap("toonmap",2D)="Black"{}
        _DirtTex("dirttex",2D)="Black"{}
        _EnvMap("envmap",2D)="Black"{}
        _EmissionTex("emissiontex",2D)="Black"{}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

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
                //float4 v1:TEXCOORD1;
                float3 worldvertexlerpnormal:TEXCOORD2;
                float3 worldvertex:TEXCOORD3;
                float3 viewvertexlerpnormal:TEXCOORD4;
                float v6:TEXCOORD5;
                float4 color:COLOR;
                float4 test:TEXCOORD6;
                float2 uv2:TEXCOORD7;
                float4 highligtcolor:TEXCOORD8;
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
            float4 _HightLightColor;
            float4 _HightLightParam;
            float4 _EmissionColor;
            float _CutOff;

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

                o.worldvertexlerpnormal=UnityObjectToWorldNormal(v.normal);
                o.highligtcolor=_HightLightColor*(1-saturate((o.worldvertex.y-_HightLightParam.x)/(_HightLightParam.y)));
                o.viewvertexlerpnormal=mul((float3x3)UNITY_MATRIX_IT_MV,v.normal);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
            //贴图采样
            //float4 envtex=tex2D(_EnvMap,xlat0.xy);//环境光贴图的采样
            //return envtex;
            float4 optionmaskmap=tex2D(_OptionMaskMap,i.uv);//
            float4 maintex=tex2D(_MainTex,i.uv);
            float4 toonmap=tex2D(_ToonMap,i.uv);
            float4 triplemaskmap=tex2D(_TripleMaskMap,i.uv);
            //return triplemaskmap;
            float4 dirttex=tex2D(_DirtTex,i.uv);//衣服的褶皱效果以及金属的反光效果
            float4 emissiontex=tex2D(_EmissionTex,i.uv);
            //return dirttex.x;
            //return optionmaskmap.z;//边缘光受环境光的影响因素

            if(triplemaskmap.z<_CutOff)
            {
                discard;
            }
            
            float4 maincolor=float4(0,0,0,1);
            maincolor.xyz=maintex.xyz*_LightColor0;
            float2 envfactor=float2(0,0);
            envfactor=lerp(float2(0,0.5),optionmaskmap.yz,_UseOptionMaskMap);
            // /return envfactor.y;
            float3 viewdir=normalize(_WorldSpaceCameraPos.xyz-i.worldvertex);
            //return _WorldSpaceLightPos0.xyzz;
            float3 lightdir=lerp(normalize(_WorldSpaceLightPos0.xyz),normalize(_OriginalDirectionalLightDir.xyz),_UseOriginalDirectionalLight>=1);
            float diffusefactor=dot(i.worldvertexlerpnormal,lightdir);
            //return diffusefactor;
            //return i.worldvertexlerpnormal.xyzz;
            float halflambert=diffusefactor*0.5+0.5;
            //return halflambert;
            float toonfactor= saturate(((_ToonStep-_ToonFeather-halflambert)/_ToonFeather)+1)*(_ToonFeather>0);
            //return toonfactor;
            float4 tooncolor=float4(0,0,0,1);
            tooncolor.xyz=toonmap.xyz*_LightColor0.xyz*_GlobalToonColor;
            float balancefactor=1-(1-i.color.w)*_VertexColorToonPower*(min(halflambert-0.5,0)+0.5)*2;
            // return balancefactor;
            //return toonfactor;
            float4 brightcolor=float4(0,0,0,1);
            brightcolor.xyz=lerp(float3(1,1,1),_ToonBrightColor.xyz,balancefactor*(0.5>=_ToonBrightColor.w))*maincolor.xyz+_ToonBrightColor.xyz*(0.5<_ToonBrightColor.w)*balancefactor;
            //return 
            float4 darkcolor=float4(0,0,0,1);
            darkcolor.xyz=lerp(float3(1,1,1),_ToonDarkColor.xyz,balancefactor*(0.5>=_ToonDarkColor.w))*tooncolor.xyz+_ToonDarkColor.xyz*(0.5<_ToonDarkColor.w)*balancefactor;
            float4 diffusecolor=float4(0,0,0,1);
            diffusecolor.xyz=lerp(brightcolor,darkcolor,toonfactor);
            //return toonfactor;
            //return brightcolor;
            //return darkcolor;
            //return diffusecolor;
            //return dirttex.y;
            float dirtfactor=dot(dirttex.xyz*_DirtScale,_DirtRate.xyz);
            //dirtfactor=0;
            //return dirtfactor;
            float3 camxdir=float3(UNITY_MATRIX_V[0].x,UNITY_MATRIX_V[1].x,UNITY_MATRIX_V[2].x);
            float3 camydir=float3(UNITY_MATRIX_V[0].y,UNITY_MATRIX_V[1].y,UNITY_MATRIX_V[2].y);
            float3 viewoffset=float3(0,0,0);
            viewoffset=lerp(viewdir,camxdir*((_RimHorizonOffset<=0)-(_RimHorizonOffset>0)),abs(_RimHorizonOffset));
            viewoffset=lerp(viewoffset,camydir*((_RimVerticalOffset<=0)-(_RimVerticalOffset>0)),abs(_RimVerticalOffset));
            float fresnelfactor=dot(viewoffset,i.worldvertexlerpnormal);
            //return fresnelfactor;
            float2 rimfactor=float2(0,0);
            rimfactor.x=pow(saturate((_RimStep-_RimFeather-fresnelfactor)/_RimFeather+1),3)*_RimColor.w;
            //return rimfactor.xxxx;
            float3 viewoffset2=float3(0,0,0);
            viewoffset2=lerp(viewdir,camxdir*((_RimHorizonOffset2<=0)-(_RimHorizonOffset2>0)),abs(_RimHorizonOffset2));
            viewoffset2=lerp(viewoffset2,camydir*((_RimVerticalOffset2<=0)-(_RimVerticalOffset2>0)),abs(_RimVerticalOffset2));
            float fresnelfactor2=dot(viewoffset2,i.worldvertexlerpnormal);
            rimfactor.y=pow(saturate((_RimStep2-_RimFeather2-fresnelfactor2)/_RimFeather2+1),3)*_RimColor.w;
            //return rimfactor.yyyy;
            //return rimfactor.y;
            //return rimfactor.x;
            //return rimfactor.y;
            //return envfactor.y;
            rimfactor=envfactor.y*rimfactor.xy;
            //return rimfactor.xxxx;
            //return rimfactor.yyyy;
            fresnelfactor = min(pow(fresnelfactor,max(_SpecularPower*10+1,0)),1)*triplemaskmap.y;
            //return fresnelfactor;
            //return triplemaskmap;
            float4 finalcolor=float4(0,0,0,1);
            finalcolor.xyz=max(_SpecularColor.xyz*_LightColor0.xyz*fresnelfactor,float3(0,0,0))+diffusecolor.xyz;
            //return finalcolor;
            //return fresnelfactor;
            //return max(_SpecularColor.xyz*_LightColor0.xyz*fresnelfactor,float3(0,0,0)).xyzz;
            float4 globalcolor=float4(0,0,0,1);
            globalcolor.xyz=lerp(_GlobalDirtColor.xyz,_GlobalDirtToonColor.xyz,toonfactor);
            finalcolor.xyz=lerp(finalcolor.xyz,globalcolor.xyz,dirtfactor);
            // return finalcolor;
            //return 1-dirttex.x;
            //return dirtfactor*5;
            float4 envmap=tex2D(_EnvMap,(i.viewvertexlerpnormal.xy+float2(1,1))*0.5);
            //return envmap;
            // return float4((i.viewvertexlerpnormal.xy+float2(1,1))*0.5,1,1);
            float4 envcolor=float4(0,0,0,1);
            envcolor.xyz=lerp(finalcolor.xyz,envmap.xyz*finalcolor.xyz*_EnvBias,envfactor.x*_EnvRate);//金属感
            //return envcolor;
            //return envfactor.xxxx;
            //return finalcolor;
            // return envfactor.xxxx;
            //return envmap;
            //return envmap*finalcolor*_EnvBias;
            //return envcolor;
            float4 rimcolor=float4(0,0,0,1);
            rimcolor.xyz=lerp(_RimColor.xyz,_SpecularColor.xyz,_RimSpecRate);
            //return rimcolor;
            rimcolor.xyz=rimfactor.x*rimcolor.xyz*(max(diffusefactor,0)+_RimShadow+_RimShadowRate);
            //return rimcolor;
            //return rimfactor.xxxx;
            // return diffusecolor;
            //return diffusefactor;
            //return max(diffusefactor,0)+_RimShadow+_RimShadowRate;
            //return rimcolor;
            //return envcolor;
            //return rimcolor*_GlobalRimColor;
            envcolor.xyz=rimcolor.xyz*_GlobalRimColor.xyz+envcolor.xyz;
            //return envcolor;
            float4 rimcolor2=float4(0,0,0,1);
            rimcolor2.xyz=lerp(_SpecularColor.xyz,_RimColor2.xyz,_RimSpecRate2)*rimfactor.y;
            envcolor.xyz=(max(diffusefactor,0)+_RimShadowRate2)*rimcolor2.xyz*_GlobalRimColor.xyz+envcolor.xyz;
            //return envcolor;
            float2 temp2= rimcolor.xy*_GlobalRimColor.xy;
            float temp=temp2.x+temp2.y+_GlobalRimColor.z*rimcolor.z;
            //return temp;
            float4 directcolor=float4(0,0,0,1);
            directcolor.xyz=(0.00001>=temp)*_GlobalDirtColor.xyz+(0.00001<temp)*_GlobalDirtRimSpecularColor.xyz;
            //return directcolor;
            //finalcolor.xyz=-envcolor.xyz;
            //return dirtfactor;
            finalcolor.xyz=lerp(envcolor.xyz,directcolor.xyz,dirtfactor);
            //return envcolor;
            //return finalcolor;
            float4 characolor=float4(0,0,0,1);
            characolor.xyz=_CharaColor.xyz*_LightProbeColor.xyz;
            float4 emissivecolor=float4(0,0,0,1);
            emissivecolor.xyz=emissiontex.xyz*_EmissionColor.xyz*(1-dirtfactor);
            //return directcolor;
            //  return i.v6;
            //  return i.highligtcolor;
            // return emissivecolor;
            //return finalcolor;
            //return finalcolor*characolor+emissivecolor+i.highligtcolor;
            finalcolor.xyz=lerp(_Global_FogColor.xyz,finalcolor.xyz*characolor.xyz+emissivecolor.xyz+i.highligtcolor.xyz,i.v6);
            float grayscale=dot(finalcolor.xyz,float3(0.2125,0.7154,0.0721));
            finalcolor.xyz=finalcolor.xyz*_Saturation+((1-_Saturation)*grayscale).xxx;
            finalcolor.w=maintex.w;

            return finalcolor;
            }
            ENDCG
        }
    }
}
