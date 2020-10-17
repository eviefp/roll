module Roll.NewComponents.Common where

import Prelude

import DOM.HTML.Indexed as D
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Roll.API.Category as Category
import Roll.API.ProductVariant as ProductVariant
import Roll.Component.Internal as I



renderProduct
    :: forall p i
     . (Category.Product -> Array (HH.IProp D.HTMLa i))
    -> Category.Product
    -> HH.HTML p i
renderProduct prop p =
    HH.li_
        [ HH.dt_
            [ HH.a
                (prop p)
                [ HH.img
                    [ HP.src "https://placeimg.com/250/150/architecture"
                    ]
                , HH.h3_
                    [ HH.text p.name
                    ]
                , HH.samp_
                    [ HH.text $ show p.price
                    ]
                ]
            ]
        , HH.dd_
            [ I.maybeElement p.description HH.text
            ]
        ]

renderProductVariant
    :: forall p i
     . (ProductVariant.ProductVariant -> Array (HH.IProp D.HTMLa i))
    -> ProductVariant.ProductVariant
    -> HH.HTML p i
renderProductVariant prop p =
    HH.li_
        [ HH.dt_
            [ HH.a
                (prop p)
                [ HH.img
                    [ HP.src "https://placeimg.com/250/150/animals"
                    ]
                , HH.h3_
                    [ HH.text p.name
                    ]
                , HH.samp_
                    [ HH.text $ show p.price
                    ]
                ]
            ]
        , HH.dd_
            [ I.maybeElement p.description HH.text
            ]
        ]
