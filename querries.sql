SELECT r.user_id, 
    SUM(
        CASE 
            WHEN r.created_at BETWEEN '2022-01-01' AND '2022-12-31'
                THEN r.reward
            ELSE 0
        END
    ) AS total_reward
FROM reports as r
WHERE
    r.user_id IN (
        SELECT 
            rp.user_id
        FROM 
            reports as rp
        WHERE 
            rp.created_at BETWEEN '2021-01-01' AND '2021-12-31'
        GROUP BY 
            rp.user_id
        HAVING 
            MIN(rp.created_at) BETWEEN '2021-01-01' AND '2021-12-31'
    );

SELECT
    p.title
    ,r.barcode
    ,r.price 
FROM 
    report as r
LEFT JOIN pos as p on r.pos_id = p.id
WHERE p.title IN (
    SELECT 
        ps.title
    FROM 
        report AS rp
    LEFT JOIN 
        pos AS ps ON rp.pos_id = ps.id
    GROUP BY 
        ps.title
    HAVING 
        COUNT(rp.id) > 1
    );
