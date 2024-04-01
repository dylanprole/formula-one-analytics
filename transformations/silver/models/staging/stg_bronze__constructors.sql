with

source as (

      select * from {{ source('bronze', 'constructors') }}

),

renamed as (

    select

        -- ids
        {{ adapter.quote("constructorId") }} as constructor_id,

        -- strings
        {{ adapter.quote("constructorRef") }} as constructor_ref,
        {{ adapter.quote("name") }} as constructor_name,
        {{ adapter.quote("nationality") }} as constructor_nationality,
        {{ adapter.quote("url") }} as constructor_url

        -- numerics

        -- booleans

        -- dates

        -- timestamps

    from source

)

select * from renamed
  