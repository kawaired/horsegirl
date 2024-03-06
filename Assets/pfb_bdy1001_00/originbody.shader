Shader "Unlit/originbody"
{
    Properties
    {
        _ToonStep("toonstep",range(0,1))=0
        _ToonFeather("toonfeather",range(0.01,1))=1
        _BrightColor("brightcolor",color)=(1,1,1,1)
        _DarkColor("darkcolor",color)=(1,1,1,1)
        _GlobalBright("globalbright",color)=(0,0,0,0)
        _GlobalDark("globaldark",color)=(0,0,0,0)
        _VertexColorToonPower("vertexcolortoonpower",range(-1,2))=1
        _EnvTex("envtex",2D)="white"{}
        _EnvRate("envrate",range(0,1))=0
        _EnvBias("envbias",range(0,1))=0
        _FoldScale("foldscale",range(0,4))=1


        _LightTex("lighttex",2D)="white"{}
        _DarkTex("darktex",2D)="white"{}
        _RimTex("rimtex",2D)="white"{}
        _FoldTex("foldtex",2D)="white"{}
        _DiffuseLight("diffuselight",color)=(0.2,0.2,0.2,0.2)
        _DiffuseRate("diffuserate",range(-2,2))=0.9
        _MetalRate("metalrate",range(-2,2))=0.2
        _ColorRate("colorrate",range(-2,2))=0
        _FastenShadowRate("fastenshadowrate",range(0,2))=0
        _DiffusePow("diffusepow",range(0.01,1))=0.5
        _DiffuseOffset("diffuseoffset",range(0.01,0.499))=0.1
        
        _SpecularLight("specularlight",color)=(0.3,0.3,0.3,0.3)
        _SpecularRate("specularrate",range(0,1))=0.2
        _RimHOffset1("rimhoffset1",range(-1,1))=0
        _RimVOffset1("rimvoffset1",range(-1,1))=0
        _RimColor1("rimcolor1",color)=(0.3,0.3,0.3,0.3)
        _RimHOffset2("rimhoffset2",range(-1,1))=0
        _RimVOffset2("rimvoffset2",range(-1,1))=0
        _RimColor2("rimcolor2",color)=(0.3,0.3,0.3,0.3)
        _RimPow("rimpow",range(1,20))=1
        _FresnelOffset("fresneloffset",range(0,1))=0
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
                float3 normal:NORMAL;
                float4 color:COLOR;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float4 worldvertex:TEXCOORD1;
                float3 worldnormal:TEXCOORD2;
                float3 viewnormal:TEXCOORD3;
                float4 color:COLOR;
            };
            float _ToonStep;
            float _ToonFeather;
            float _FoldScale;

            sampler2D _LightTex;
            float4 _LightTex_ST;
            sampler2D  _DarkTex;
            float4 _DarkMain_ST;
            sampler2D _RimTex;
            float4 _RimTex_ST;
            sampler2D _FoldTex;
            float4 _FoldTex_ST;
            sampler2D _EnvTex;
            float4 _EnvTex_ST;

            float4 _BrightColor;
            float4 _DarkColor;
            float4 _GlobalBright;
            float4 _GlobalDark;
            float _VertexColorToonPower;
            float _EnvRate;
            float _EnvBias;

            float4 _DiffuseLight;
            float _DiffuseRate;
            float _MetalRate;
            float _ColorRate;
            float _FastenShadowRate;
            float _DiffusePow;
            float _DiffuseOffset;
            float4 _SpecularLight;
            float _SpecularRate;
            float _RimHOffset1;
            float _RimVOffset1;
            float4 _RimColor1;
            float _RimHOffset2;
            float _RimVOffset2;
            float4 _RimColor2;
            float _RimPow;
            float _FresnelOffset;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _LightTex);
               o.worldvertex=mul((float4x4)unity_ObjectToWorld,v.vertex);
               o.worldnormal=UnityObjectToWorldNormal(v.normal);
               o.viewnormal=mul(UNITY_MATRIX_IT_MV,v.normal);
               o.color=v.color;
                return o;
            }

            float ZeroStep(float x)
            {
                return (x>=0)-(x<0);
            }

            float3 OffsetVector(float3 origionvector,float3 aimvector,float offsetvalue)
            {
                return  lerp(origionvector,aimvector*(ZeroStep(offsetvalue)),abs(offsetvalue));
            }

            float Sigmoid(float x)
            {
                return 1/(1+pow(2,-x));
            }

            fixed4 frag (v2f i) : SV_Target
            {
                //return i.worldnormal.xyzz;
                //return i.viewnormal.xyzz;
                float4 lighttex=tex2D(_LightTex,i.uv);
                float4 darktex=tex2D(_DarkTex,i.uv);
                // return darktex;
                float4 rimtex=tex2D(_RimTex,i.uv);//y轴表示材质的区分
                // return rimtex.zzzz;
                // return rimtex.y;
                float4 foldtex=tex2D(_FoldTex,i.uv);//x轴漫反射容易出现阴影的区域的程度，y轴表示金属区域的高光反射显示区域
                //return foldtex.y;
                //return foldtex.x;
                float3 mylight=normalize(float3(0,0,1));
                float lambert=dot(i.worldnormal,_WorldSpaceLightPos0);
                //return i.worldnormal.xyzz;
                //float lambert=dot(i.worldnormal,mylight);
                //return lambert;
                float halflambert=lambert*0.5+0.5;
                //return halflambert;
                float halffactor=min(halflambert-0.5,0)+0.5;
                // return halffactor;
                //float lambertfactor=0.5*(lambert+1)*foldtex.x;
                //float lambertfactor=saturate(((_ToonStep-_ToonFeather-(halffactor+foldtex.x*0.25))/_ToonFeather)+1)*(_ToonFeather>0);
                float lambertfactor=saturate(((_ToonStep-_ToonFeather-(halflambert*foldtex.x))/_ToonFeather)+1);
                //float lambertfactor=saturate(((_ToonStep-_ToonFeather-(foldtex.x))/_ToonFeather)+1);
                //return foldtex.x>0.6;
                // return lambertfactor;
                
                float4 maindiffuse=lerp(lighttex,darktex,lambertfactor);
                // return maindiffuse;
                // float4 metaldiffuse=foldtex.y*maindiffuse;
                // return maindiffuse;
                // float4 diffusecolor=maindiffuse+metaldiffuse;
                float4 diffusecolor=maindiffuse*(1+foldtex.y);
                // return diffusecolor;
                float4 envtex=tex2D(_EnvTex,(i.viewnormal.xy+float2(1,1))*0.5);
                // return envtex;
                float4 specularcolor=rimtex.y*envtex*_SpecularLight*_SpecularRate;   
                // return specularcolor;             
                float3 viewdir=normalize(_WorldSpaceCameraPos.xyz-i.worldvertex.xyz);
                float3 camxdir=float3(UNITY_MATRIX_V[0].x,UNITY_MATRIX_V[1].x,UNITY_MATRIX_V[2].x);
                float3 camydir=float3(UNITY_MATRIX_V[0].y,UNITY_MATRIX_V[1].y,UNITY_MATRIX_V[2].y);
                float3 offsetviewdir1=OffsetVector(viewdir,camxdir,_RimHOffset1);
                offsetviewdir1=OffsetVector(offsetviewdir1,camydir,_RimVOffset1);
                float fresnel1=dot(offsetviewdir1,i.worldnormal);
                //fresnel1=pow(1-fresnel1-_FresnelOffset/fresneloffset,_RimPow);
                fresnel1=pow(saturate(_FresnelOffset-fresnel1),_RimPow);
                //return rimtex.z;
                float4 rimcolor1=(fresnel1>0.9)*rimtex.z*_RimColor1;
                //return rimcolor1;
                float4 finalcolor=specularcolor+diffusecolor+rimcolor1;
                return finalcolor;
            }
            ENDCG
        }
    }
}
